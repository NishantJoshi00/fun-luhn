# How to Contribute

I am really glad you are reading this, following are some of the basic guidelines that we try to adhere to to make this project a success.

Contribution can be of 4 types

1. New language implementation
2. Improvement to old implementation
3. Adding regression test cases
4. Improvement to the testing/CI framework

## 1. New language implementation

Awesome! This is what we want more of! Please first make sure if the implementation already exists/someone has raised a PR for the same.

If the implementation already exists don't lose heart, you now have an unique opportunity to fall into the 2nd category of contributors, and if a PR is open for the same you can collaborate with the author to come up with a even better solution.

To add a new language in the set, following are some of the changes that you will need to do to qualify for contribution

- Add & Mention the language you are implementing in the [README](./README.md)
- Create a folder with the name of the language and add an `.env` file, containing the following lines
  - `export BUILD="<command>"` The command to build the project
  - `export COMMAND="<command>"` The command to run the project
- The implementation needs to do the following.
  It should take a single line as input from `stdin` which will be the card numuber and return either `Ok` or `Failed` in corresponding cases. In case of invalid input the output doesn't matter but the status code should be non-zero.
- Try as much possible to write the implementation without much help of external dependencies
- Try to use as fewer external dependencies while writing the implementation for the programs

## 2. Improvement to old implementation

Glad to have you guys here! Always open for improvements in the existing implementation please go ahead. Following are some pointers to keep in mind regarding the contribution

- Please verify that your solution of actually having a significant impact in the execution time compared to the current solution
- If this is an design improvement, make sure that it doesn't affect the runtime speed of the solution, and justify the need to do the same

## 3. Adding regression test cases

The simplest kind! we are maintaining a good list and a bad list of test cases to be used for regression, you can just add test cases in either of the lists to qualify as a contribution.

Some points to keep in mind

- For this contribution the addition should be atleast 10+ cases
- The added cases should be unique and valid

## 4. Improvement to the testing/CI framework

Work from the shadows! If you feel like the current testing framework can be improved by any means please go ahead. Following are some things to keep in mind for these type of contribution

- Please create a issue, around the improvement or feature that you are planning to work on.
- If the issue if valid and approved for development by the maintainers you can go ahead with the development

## General guidelines

Following are some of the things to keep in mind, when contributing to the repository

- Follow basic code etiquettes while naming variables, functions and comments in the code
- Stay respectful towards other fellow contributors in the discussions
- Let's try and have fun together learning, developing and writing code
