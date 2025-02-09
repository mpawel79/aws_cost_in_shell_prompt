#!/bin/bash

# Function to get AWS costs for the current month
get_previous_hour_cost() {
    # Calculate the start (1st of current month) and end time (current day) for monthly costs
    start_time=$(date -u "+%Y-%m-01")
    end_time=$(date -u "+%Y-%m-%d")

    echo "Fetching AWS cost data..." >&2
    # Get the cost for the current month
    cost=$(aws ce get-cost-and-usage \
        --time-period Start=$start_time,End=$end_time \
        --granularity MONTHLY \
        --metrics "BlendedCost" \
        --query "ResultsByTime[0].Total.BlendedCost.Amount" \
        --output text)

    # Check if cost is empty
    if [ -z "$cost" ]; then
        cost="0.00"  # Default to 0.00 if no cost is found
    fi

    # Round to 2 decimal places
    printf "%.2f" $cost
}

# Function to check if we need to update the cost
should_update_cost() {
    # If the last check time is not set, we should update
    if [ -z "$LAST_COST_CHECK" ]; then
        return 0
    fi

    # Get current timestamp
    current_time=$(date +%s)
    
    # Calculate time difference in seconds
    time_diff=$((current_time - LAST_COST_CHECK))
    
    # Update if more than 1 hour has passed (3600 seconds)
    if [ $time_diff -ge 3600 ]; then
        return 0
    else
        return 1
    fi
}

# Function to update cost if needed
update_cost() {
    # Force update if AWS_COST is empty or "0.00"
    if [ -z "$AWS_COST" ] || [ "$AWS_COST" = "0.00" ] || should_update_cost; then
        echo "Updating cost..." >&2
        export AWS_COST=$(get_previous_hour_cost)
        echo "New cost: $AWS_COST" >&2
        export LAST_COST_CHECK=$(date +%s)
    fi
}

# Ensure initial cost is set
if [ -z "$AWS_COST" ]; then
    export AWS_COST="$NA"
fi

# Get user and computer name
user=$(whoami)
computer_name=$(hostname)

# Format the prompt with the cached cost
# Adding $ before the cost value
PS1="${user}@${computer_name} \w (\$${AWS_COST}) % "

# Make sure update_cost runs first, then update PS1
PROMPT_COMMAND='update_cost; PS1="${user}@${computer_name} \w (\$${AWS_COST}) % "'

# Force initial update
update_cost
