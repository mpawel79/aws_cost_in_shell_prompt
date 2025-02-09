# AWS Cost Shell Prompt

A Bash shell prompt customization that displays your current AWS monthly costs directly in your terminal prompt. The cost updates hourly to help you keep track of your AWS spending in real-time.

## Preview

Your prompt will look like this:
```bash
username@hostname /current/path ($0.11) %
```

## Prerequisites

- AWS CLI installed and configured with appropriate permissions
- Access to AWS Cost Explorer API
- Bash shell

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/aws-cost-shell-prompt.git
cd aws-cost-shell-prompt
```

2. Make the script executable:
```bash
chmod +x aws_cost_shell_prompt.sh
```

3. Add the script to your shell profile:
```bash
echo "source $(pwd)/aws_cost_shell_prompt.sh" >> ~/.bashrc  # for Linux
# or
echo "source $(pwd)/aws_cost_shell_prompt.sh" >> ~/.bash_profile  # for macOS
```

4. Reload your shell profile:
```bash
source ~/.bashrc  # for Linux
# or
source ~/.bash_profile  # for macOS
```

## Features

- Displays current AWS monthly costs in your shell prompt
- Updates cost information hourly to minimize API calls
- Caches the cost data between updates
- Shows costs in USD with dollar sign
- Works on both Linux and macOS

## AWS Permissions Required

Your AWS user needs the following permissions:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ce:GetCostAndUsage"
            ],
            "Resource": "*"
        }
    ]
}
```

## Customization

You can modify the prompt format by editing the `PS1` variable in the script. The current format is:
```bash
PS1="${user}@${computer_name} \w (\$${AWS_COST}) % "
```

## Troubleshooting

1. If you see `($AWS_COST)` instead of the actual cost:
   - Make sure you've sourced the script properly
   - Check your AWS credentials

2. If you see `($0.00)`:
   - Verify your AWS Cost Explorer access
   - Check if you have any costs in the current month

3. If the script isn't updating:
   - Check if the `PROMPT_COMMAND` is set correctly
   - Verify the update interval (default is 1 hour)

## Contributing

Feel free to submit issues and enhancement requests!

## License

[MIT License](LICENSE) 
