# Scrapper

![tictactoe-example](https://res.cloudinary.com/erezfriemagor/image/upload/v1615212764/2021-03-08_14_11_11-erez_DESKTOP-JP7JKBA___scrapping_project_bin.png)

## Built With

- Ruby
- Vscode
- Rubocop

## How to Use

The scrapper is a script file  that was built in order  to pull essential data of a Github's user from Github.
The user will be asked by the terminal to enter either a git hub username or a link to the git hub profile.

Provided that the scrapper has confirmed that the user account or the link is valid(otherwise, the user will be asked to re-enter the input)
the scrapper will

1)Output to the terminal essential information about the account
2)save that information into a data.csv file
 
### Prerequisites

If you intend to download the project, you will need to have Ruby already installed on your machine. For more information on how to install Ruby, follow [this link](https://www.ruby-lang.org/en/downloads/).

### Installation Instructions

To get your own copy of the project simply clone the repository to your local machine.

**Step 1**: Using the Command Line, navigate into the location where you would like to have the repository. Then enter the following line of code:

```
`git clone https://github.com/erezfree29/scrapper.git
```

**Step 2**: Once the repo has been cloned, navigate inside it by entering the following command:

`cd scrapper`

**Step 3**: Run bundle install in order to install the gems listed within the gem file.

**Step 4**: Once in the root directory of the repository, simply enter the following line of code to start a game:

`bin/scrapper`

Follow the subsequent instructions that appear in the Terminal.

## Repository Contents

The code for the project is located in the  **./bin** folder.

The **./bin** folder contains the executable **scrapper**  file in which methods are to be run.
The **./lib** folder contains the methods.rb file which includes the methods being used by the scrapper file.
The **./spec** contains 
 spec_helper.rb default rspec files
 methods_spec.rb a file created for checking all the methods in the methods.rb file
 print_hush_info.rb a file created in order to test the print_hush_info method by running the file and assigning its output to a variable


In addition to the above, the repo also contains .
.rspec created by the rspec gem
rubocop.yml for linting.
license file for am Mit license.
data.csv file and example csv file which has been created by running the save_to_csv method.
This readme file.

Gemfile where the gems(which allow additional important functionality) are listed gems used are
gem 'rubysl-open-uri', '~> 2.0' - used for impotring plain html text from the website
gem 'nokogiri', '~> 1.11', '>= 1.11.1' - converting plain text into a type doc object
gem 'csv', '~> 0.0.1' - for writing into a new csv file
gem 'colorize', '~> 0.8.1' - outputing colorful text to the terminal 
gem 'rspec', '~> 3.5' used in order to create tests and run them.
gem 'rubocop', '~> 0.39.0'desgined to ensure good coding practises

## Running the tests instructions
In order to run the tests simply type rspec from the root folder of the project 


✒️  Author
👤 **Erez Friemagor**
- Github: [@erezfree29](https://github.com/erezfree29)
- Linkedin: [Erez Friemagor](https://www.linkedin.com/in/mert-gunduz-875280202/)


## Show your support ⭐️⭐️

If you've read this far....give a star to this project ⭐️!

## 📝 License

This project has an Mit License ,description can be found in the license file in the root directory.
