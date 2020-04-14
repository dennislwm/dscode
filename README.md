# dscode
Docker starter project for Digital Ocean ["DO"] droplet.

---
### About dscode
**dscode** was a personal project to:
- automate SSH key generation and uploading to remote server
- automate droplet creation in a remote server
- automate package installation in a remote server
- automate make swapfile in a remote server
- automate docker-compose in a remote server
- automate restore files to a remote server
- automate backup files from a remote server

---
### Automate SSH Key Generation and Upload

The main resource file, main.tf, has a shared resource objSshKey.

The SSH token string is stored in the root terraform.tfvars file (add to .gitignore).

---
### Automate Droplet Creation in a DigitalOcean account

The main resource file, main.tf, has a declaration for each module, e.g. couchdb, teedy, etc.

In each module folder, a resource file declares a droplet and a project.

In each module folder, a variable file overrides the default root variable file.

For example, changing the default value of strDoImage to "docker-18-04".

---
### Automate Provisioning of Server

In each module, we perform the following in Terraform via a SSH connection:

- provision for creating remote folders.

- provision for copying local data files to a remote server.

- provision for making a swapfile in a remote server.

- provision for executing a docker-compose command in a remote server.

- return the server IP address at completion.

---
### Automate Backup of Files from Server

TODO: In each module, provision for backing up the remote files to local folders.

---
### Project Structure
     dscode/                          <-- Root of your project
       |- package.json                <-- Node.js project entries
       |- README.md                   <-- This README markdown file
       +- bin/                        <-- Holds any executable files
          |- mkswap.sh                <-- Creates a swapfile in a Bash terminal for production
       +- config/                     <-- Holds any configuration files
          |- batchfile.txt            <-- List of IP addresses for Gulp (deprecated)
          |- ssh.conf                 <-- SSH configuration file
       +- docker-couchdb/             <-- Holds any docker files for CouchDB
          |- docker-compose.yml       <-- Docker compose file for production
          |- docker-compose-win.yml   <-- Docker compose file for development
       +- docker-teedy/               <-- Holds any docker files for Teedy
          |- docker-compose.yml       <-- Docker compose file for production
       +- js/                         <-- Holds any Javascript files
          |- gulp.js                  <-- Automate scripts for deployment (deprecated)
          |- gulp-plus.js             <-- Custom include library (deprecated)
       +- tf/                         <-- Terraform root folder
          |- main.tf                  <-- Main TF file (required)
          |- variables.tf             <-- Default variables declaration file for root
          |- outputs.tf               <-- Default outputs declaration file for root
          |- terraform.tfvars         <-- Secret variables declaration file for tokens (.gitignore)
          +- modules/                 <-- Nested modules
             +- couchdb/              <-- Holds any TF files for CouchDB
                |- couchdb.tf         <-- Resources TF file
                |- variables.tf       <-- Overrides inputs of variables.tf file in root
                |- outputs.tf         <-- Returns outputs in module to main.tf file in root
             +- jitsi/                <-- Holds any TF files for Jitsi
                |- jitsi.tf           <-- Resources TF file
                |- variables.tf       <-- Overrides inputs of variables.tf file in root
                |- outputs.tf         <-- Returns outputs in module to main.tf file in root
             +- teedy/                <-- Holds any TF files for Teedy
                |- couchdb.tf         <-- Resources TF file
                |- variables.tf       <-- Overrides inputs of variables.tf file in root
                |- outputs.tf         <-- Returns outputs in module to main.tf file in root

---
### Prerequisite

* [Terraform](https://terraform.io)

## Infrastructure as Code

### Initialize Terraform Nested Modules

In the Terraform root folder, type the following command in your terminal:

     $ terraform init

---

### Create a Terraform Plan

Type the following command in your terminal:

     $ terraform plan

---

### Execute a Terraform Plan

Type the following command in your terminal:

     $ terraform apply

Before typing 'yes', ensure that ALL resources Terraform will create and **destroy** are correct.

---

### Destroy a Terraform Plan

Type the following command in your terminal:

     $ terraform destroy

Before typing 'yes', ensure that ALL resources Terraform will **destroy** are correct.

---

### Reach Out!
Please consider giving this repository a star on GitHub.

---
### License
The **dscode** source code is licensed under the [GPL-3.0 license](https://github.com/dennislwm/dscode/blob/master/LICENSE).