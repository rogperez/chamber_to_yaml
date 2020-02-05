# About

This script will turn your chamber output into a secrets.yaml file or a
visibles.yaml file. The script will also convert the keynames into full caps
and base 64 encode the values in the secrets.yaml.

# Installation

Clone the repo and make the script executable

```
chmod +x chamber_to_yaml.rb
```

# Usage

Simply provide the script with a command that returns the chamber values and
follow the prompts provided by the script.

```
./chamber_to_yaml.rb "CHAMBER_AWS_REGION=us-north-2 chamber list -e my_secrets"
```

*Note*: the chamber values must be in the following format:

```
Key                             Version         LastModified    User                             Value
SES_SERVER                      0               08-29 17:36:29  arn:aws:iam::xxxx:user/xxx.yyy   foo.server.bar
```

Once all values have been defined as either secret, or visible, they will be
placed in a secrets.yaml or visibles.yaml file respectively.

