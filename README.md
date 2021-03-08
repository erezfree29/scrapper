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

The **./bin** folder contains the executable **scrapper.rb**  file.

In addition to the above, the repo also contains .
rubocop.yml for linting.
license file for am Mit license
This readme file.

Gemfile where the gems(which allow additional important functionality) are listed gems used are
gem 'rubysl-open-uri', '~> 2.0'  #used for impotring plain html text from the website
gem 'nokogiri', '~> 1.11', '>= 1.11.1' # converting plain text into a type doc object
gem 'csv', '~> 0.0.1' # for writing into a new csv file
gem 'colorize', '~> 0.8.1' # outputing colorful text to the terminal 

✒️  Author
👤 **Erez Friemagor**
- Github: [@erezfree29](https://github.com/erezfree29)
- Linkedin: [Erez Friemagor](https://www.linkedin.com/in/mert-gunduz-875280202/)


## Show your support ⭐️⭐️

If you've read this far....give a star to this project ⭐️!

## 📝 License

This project has an Mit License ,description can be found in the license file in the root directory.
