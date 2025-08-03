# Deploying a Simple Python Web Application to Azure App Service

## Real-World Problem Scenario

A startup needs to rapidly deploy a web application, such as a customer feedback portal or a simple blog, with minimal operational overhead. The primary focus is on application development and business logic, rather than managing underlying server infrastructure.

## Why This Matters & Our Architectural Approach

### Problem

Even with cloud VMs, managing the operating system (OS) still involves tasks like patching, security updates, and configuring scaling. This diverts valuable developer time and resources away from core application development.

### Why This Way

Azure App Service is a Platform-as-a-Service (PaaS) offering that abstracts away the complexities of server infrastructure management, allowing developers to concentrate solely on writing and deploying their application code.  
It supports a wide range of programming languages and frameworks, including .NET, Node.js, Python, and Java.

App Service provides built-in features such as:

- Autoscaling  
- Load balancing  
- Continuous deployment capabilities  

These are essential for modern application development.

This approach strongly aligns with:

- **Operational Excellence** by reducing management burden  
- **Performance Efficiency** through automatic scaling  
- **Cost Optimization** by only paying for the compute resources consumed by the application  

This demonstrates a clear progression from **IaaS (VMs)** to **PaaS**, emphasizing developer productivity and automation as key benefits of cloud-native development.

## Azure Services Involved

- Azure App Service  
- App Service Plan  
- Azure DevOps (for CI/CD, optional but recommended)


This guide provides step-by-step instructions for deploying a simple Python web application (using Flask as an example) to Azure App Service. We'll cover setting up your local environment, creating the Azure resources, configuring your app for deployment, and troubleshooting common issues.

## Table of Contents

1.  Prerequisites
2.  Step 1: Prepare Your Local Development Environment
3.  Step 2: Create Your Simple Python Web App
4.  Step 3: Create Azure Resources](#step-3-create-azure-resources
5.  Step 4: Configure Your Azure Web App for Python
6.  Step 5: Deploy Your Application
7.  Step 6: Verify Deployment and Access Your App
8.  Troubleshooting and Best Practices

---

## 1. Prerequisites

Before you begin, ensure you have the following:

* **Azure Account:** An active Azure subscription. If you don't have one, you can [create a free account](https://azure.microsoft.com/free/).
* **Python:** Python 3.9 or higher installed on your local machine.
    * [Download Python](https://www.python.org/downloads/)
* **Azure CLI:** The Azure Command-Line Interface installed. This tool allows you to interact with Azure services from your terminal.
    * [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    * Log in: `az login`
* **Git:** Git installed on your local machine for version control and deployment.
    * [Download Git](https://git-scm.com/downloads)
* **Text Editor/IDE:** A code editor like Visual Studio Code (VS Code) is highly recommended.
    * [Download VS Code](https://code.visualstudio.com/)
    * **VS Code Extensions (Recommended):**
        * Python extension
        * Azure App Service extension
        * Azure Tools extension

---

## Step 1: Prepare Your Local Development Environment

It's a best practice to use a virtual environment for your Python projects to manage dependencies.

1.  **Create a Project Directory:**
    ```bash
    mkdir my-python-app
    cd my-python-app
    ```

2.  **Create a Virtual Environment:**
    ```bash
    python -m venv venv
    ```

3.  **Activate the Virtual Environment:**
    * **Windows:**
        ```bash
        .\venv\Scripts\activate
        ```
    * **macOS/Linux:**
        ```bash
        source venv/bin/activate
        ```
    (You'll see `(venv)` in your terminal prompt, indicating the virtual environment is active.)

---

## Step 2: Create Your Simple Python Web App

For this example, we'll create a basic Flask application.

1.  **Install Flask:**
    ```bash
    pip install Flask gunicorn
    ```
    * **Flask:** Our web framework.
    * **Gunicorn:** A WSGI HTTP server that Azure App Service uses to run Python applications in production.

2.  **Create `app.py`:**
    Create a file named `app.py` in your `my-python-app` directory with the following content:

    ```python
    from flask import Flask
    import os

    app = Flask(__name__)

    @app.route('/')
    def hello_world():
        return 'Hello from Azure App Service with Python!'

    @app.route('/env')
    def show_env():
        # Display some environment variables
        app_name = os.environ.get('WEBSITE_SITE_NAME', 'Not Set')
        python_version = os.environ.get('WEBSITE_PYTHON_VERSION', 'Not Set')
        return f'App Name: {app_name}<br>Python Version: {python_version}'

    if __name__ == '__main__':
        # For local development only. Gunicorn will be used in production.
        app.run(host='0.0.0.0', port=5000)
    ```

3.  **Create `requirements.txt`:**
    This file lists all the Python packages your application depends on. Azure App Service will read this file to install dependencies.

    ```bash
    pip freeze > requirements.txt
    ```
    Verify the `requirements.txt` file contains `Flask` and `gunicorn`.

    ```text
    # Example content of requirements.txt
    Flask==X.Y.Z
    gunicorn==A.B.C
    # ... other dependencies if any
    ```

4.  **Test Your App Locally (Optional but Recommended):**
    ```bash
    python app.py
    ```
    Open your browser and navigate to `http://127.0.0.1:5000/`. You should see "Hello from Azure App Service with Python!".

---

## Step 3: Create Azure Resources

You can create Azure resources using the Azure Portal or Azure CLI. Using the CLI is faster for automation and scripting.

### Option A: Using Azure CLI (Recommended)

Replace `<your-resource-group-name>`, `<your-app-service-plan-name>`, and `<your-webapp-name>` with unique names. Your web app name must be globally unique.

1.  **Create a Resource Group:**
    A resource group is a logical container for your Azure resources.
    ```bash
    az group create --name <your-resource-group-name> --location eastus
    ```
    * You can choose a different `--location` (e.g., `westus`, `westeurope`, `canadacentral`).

2.  **Create an App Service Plan:**
    An App Service Plan defines the underlying compute resources for your web app. We'll use a Linux plan.
    ```bash
    az appservice plan create \
      --name <your-app-service-plan-name> \
      --resource-group <your-resource-group-name> \
      --sku B1 \
      --is-linux
    ```
    * `--sku B1`: This is the Basic tier, suitable for development and testing. For production, consider `S1` (Standard) or higher.
    * `--is-linux`: Specifies that this plan is for Linux-based apps, which is required for Python on App Service.

3.  **Create the Web App:**
    This command creates the web app within your App Service Plan and specifies the Python runtime.
    ```bash
    az webapp create \
      --name <your-webapp-name> \
      --resource-group <your-resource-group-name> \
      --plan <your-app-service-plan-name> \
      --runtime "PYTHON|3.9"
    ```
    * `--runtime "PYTHON|3.9"`: Specifies Python 3.9. You can use other versions like `PYTHON|3.10`, `PYTHON|3.11`, etc., if available.

### Option B: Using Azure Portal

1.  **Log in to Azure Portal:** Go to [portal.azure.com](https://portal.azure.com/).
2.  **Create a Resource Group:**
    * Click "Create a resource" -> "Resource group" or search for "Resource groups".
    * Click "Create".
    * Fill in Subscription, Resource group name (e.g., `my-python-app-rg`), and Region. Click "Review + create", then "Create".
3.  **Create an App Service:**
    * Click "Create a resource" -> "Web App" or search for "Web App".
    * Click "Create".
    * **Basics tab:**
        * **Subscription:** Your Azure Subscription.
        * **Resource Group:** Select the one you just created (`my-python-app-rg`).
        * **Name:** Enter a globally unique name for your web app (e.g., `my-simple-flask-app-12345`).
        * **Publish:** Select "Code".
        * **Runtime stack:** Select "Python 3.9" (or your preferred version).
        * **Operating System:** Select "Linux".
        * **Region:** Select the same region as your resource group.
        * **App Service Plan:**
            * Click "Create new".
            * Enter a name (e.g., `my-flask-app-plan`).
            * **Sku and size:** Click "Change size" and select a Basic (B1) or Standard (S1) tier.
            * Click "Apply".
    * Click "Review + create", then "Create".

---

## Step 4: Configure Your Azure Web App for Python

Azure App Service needs to know how to start your Python application.

1.  **Set Startup Command:**
    By default, App Service looks for a WSGI file named `application.py` or `wsgi.py`. For our `app.py` and Gunicorn, we need to specify a custom startup command.

    The recommended startup command for a Flask app using Gunicorn is:
    `gunicorn --bind 0.0.0.0 --worker-class gevent --workers 4 app:app`
    * `gunicorn`: The WSGI HTTP server.
    * `--bind 0.0.0.0`: Binds to all network interfaces.
    * `--worker-class gevent`: Specifies the worker class. `gevent` is often recommended for performance.
    * `--workers 4`: Number of Gunicorn workers (adjust based on your app's needs and App Service plan).
    * `app:app`: This tells Gunicorn to find the `app` object (your Flask application instance) within the `app.py` file. If your app instance was `my_flask_app` in `main.py`, it would be `main:my_flask_app`.

    ### Option A: Using Azure CLI
    ```bash
    az webapp config set \
      --resource-group <your-resource-group-name> \
      --name <your-webapp-name> \
      --startup-file "gunicorn --bind 0.0.0.0 --worker-class gevent --workers 4 app:app"
    ```

    ### Option B: Using Azure Portal
    1.  Navigate to your Web App in the Azure Portal.
    2.  In the left-hand menu, under **Settings**, click on **Configuration**.
    3.  Go to the **General settings** tab.
    4.  In the **Startup Command** field, enter: `gunicorn --bind 0.0.0.0 --worker-class gevent --workers 4 app:app`
    5.  Click **Save**.

2.  **Set App Settings (Environment Variables):**
    You can add environment variables that your application can access. These are typically used for configuration, connection strings, or secrets.

    ### Option A: Using Azure CLI
    ```bash
    az webapp config appsettings set \
      --resource-group <your-resource-group-name> \
      --name <your-webapp-name> \
      --settings MY_CUSTOM_VARIABLE="MyValue" ANOTHER_SETTING="AnotherValue"
    ```

    ### Option B: Using Azure Portal
    1.  Navigate to your Web App in the Azure Portal.
    2.  In the left-hand menu, under **Settings**, click on **Configuration**.
    3.  Go to the **Application settings** tab.
    4.  Click "+ New application setting".
    5.  Enter `Name` and `Value`. Check "Deployment slot setting" if you are using deployment slots and want the setting to stick to a slot.
    6.  Click **OK**, then **Save**.

---

## Step 5: Deploy Your Application

There are several ways to deploy your Python app to Azure App Service. We'll cover two common methods: Azure CLI (Zip Deploy) and Local Git.

### Method 1: Deploy using Azure CLI (`az webapp up`) - Easiest for Quick Deployments

The `az webapp up` command simplifies deployment by zipping your current directory, deploying it, and configuring some settings automatically.

1.  **Navigate to your app directory:**
    ```bash
    cd my-python-app
    ```

2.  **Ensure Git repository is initialized (for some `az webapp up` features):**
    ```bash
    git init
    ```
    (Optional, but good practice. `az webapp up` works even without a local Git repo, but can leverage it.)

3.  **Run the deployment command:**
    ```bash
    az webapp up \
      --name <your-webapp-name> \
      --resource-group <your-resource-group-name> \
      --runtime "PYTHON:3.9" \
      --startup-command "gunicorn --bind 0.0.0.0 --worker-class gevent --workers 4 app:app"
    ```
    * This command will:
        * Create the web app (if it doesn't exist).
        * Package your code.
        * Deploy it to App Service.
        * Set the Python runtime.
        * Set the startup command.

    **Note:** If you already created the web app and set the startup command in Step 4, you can omit `--runtime` and `--startup-command` from `az webapp up`. However, including them ensures the settings are correct.

    The deployment process will automatically install dependencies from `requirements.txt`. Azure App Service detects the Python project by the presence of `requirements.txt`.

### Method 2: Deploy using Local Git (for more controlled deployments)

This method involves pushing your code to a Git repository hosted by Azure App Service.

1.  **Initialize Git in your project directory (if not already done):**
    ```bash
    cd my-python-app
    git init
    ```

2.  **Configure Azure Deployment Credentials:**
    You need to set up deployment credentials (username and password) for your App Service. This is different from your Azure account login.
    ```bash
    az webapp deployment user set --user-name <your-deployment-username> --password <your-deployment-password>
    ```
    * Choose a strong username and password. Remember these!

3.  **Add your files to Git:**
    ```bash
    git add .
    git commit -m "Initial commit for Azure deployment"
    ```

4.  **Get the Git deployment URL for your Web App:**
    ```bash
    az webapp deployment source config-local-git \
      --name <your-webapp-name> \
      --resource-group <your-resource-group-name> \
      --query "url" -o tsv
    ```
    This command will output a URL like `https://<your-webapp-name>.scm.azurewebsites.net/<your-webapp-name>.git`. Copy this URL.

5.  **Add Azure remote to your local Git repository:**
    ```bash
    git remote add azure <THE_GIT_DEPLOYMENT_URL_YOU_COPIED>
    ```

6.  **Push your code to Azure:**
    ```bash
    git push azure master
    ```
    You will be prompted for the deployment username and password you set in step 2.
    * The deployment output will show the progress, including `pip install -r requirements.txt`.

### Important Setting for Build During Deployment

For both methods, especially when using Git or ZIP deployments, ensure that App Service is configured to build (install dependencies) during deployment. This is usually the default, but if you encounter issues, verify this setting.

**`SCM_DO_BUILD_DURING_DEPLOYMENT`** environment variable:

* **Value:** `true` (default for Python apps)
* **Purpose:** Tells Azure's Kudu deployment engine to run the build process (which includes installing `requirements.txt`) when code is deployed.

You can set this via CLI if needed:
```bash
az webapp config appsettings set \
  --resource-group <your-resource-group-name> \
  --name <your-webapp-name> \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true
```

Or via Azure Portal under **"Configuration" -> "Application settings"**.

## Step 6: Verify Deployment and Access Your App

### Get your Web App URL:

#### Bash

```bash
az webapp show \
  --name <your-webapp-name> \
  --resource-group <your-resource-group-name> \
  --query "defaultHostName" -o tsv
```

This will output `your-webapp-name.azurewebsites.net`.

### Access Your Application:

Open your web browser and navigate to:

```
http://<your-webapp-name>.azurewebsites.net/
```

You should see:

```
Hello from Azure App Service with Python!
```

Try:

```
http://<your-webapp-name>.azurewebsites.net/env
```

to see the environment variables.

---

## Troubleshooting and Best Practices

### Common Deployment Issues and Solutions

#### **pip install failures / Missing Dependencies**

- **Symptom**: Your app crashes with `ModuleNotFound` errors or similar.
- **Cause**: `requirements.txt` is missing, malformed, or dependencies failed to install.
- **Solution**:
  - Ensure `requirements.txt` is correctly generated:

    ```bash
    pip freeze > requirements.txt
    ```

  - Check deployment logs (see below) for `pip install` errors.
  - Verify `SCM_DO_BUILD_DURING_DEPLOYMENT` is true.
  - Some packages require system-level libraries. App Service Linux has many pre-installed, but for others, you might need a custom Docker image or use Azure Container Apps.

#### **Incorrect Startup Command**

- **Symptom**: "Application Error" or "HTTP Error 500" page, gunicorn not found, or app doesn't start.
- **Cause**: The startup-file (or "Startup Command" in portal) is incorrect, or Gunicorn isn't correctly configured.
- **Solution**:
  - Double-check the startup command in Step 4.
  - Ensure `app:app` (or `your_module:your_flask_app_instance`) correctly points to your application.
  - Access the Kudu console and try running the command manually to debug.

---

## Application Logs

The most crucial tool for debugging.

### **Azure Portal**

1. Navigate to your Web App.
2. Under **Monitoring**, click on **App Service logs**.
3. Toggle **"Application Logging (Filesystem)"** to **On** and set the Retention Period (e.g., 3 days). Click **Save**.
4. Under **Monitoring**, click on **Log stream**. This shows real-time logs from your application.

### **Azure CLI**

#### Bash

```bash
az webapp log tail --name <your-webapp-name> --resource-group <your-resource-group-name>
```

### **Kudu Console (Advanced)**

1. Navigate to:

   ```
   https://<your-webapp-name>.scm.azurewebsites.net/
   ```

2. Click **"Debug console" -> "CMD" or "Bash"**.
3. You can:
   - Navigate the file system (`site/wwwroot` is where your code lives),
   - Check logs in `LogFiles`,
   - Try running commands manually.  
     This is very powerful for debugging deployment issues.

---

## Virtual Environment Issues

- **Symptom**: App works locally but fails on Azure, possibly due to a virtual environment being deployed.
- **Cause**: You accidentally committed and pushed your local `venv` directory.
- **Solution**: Add `venv/` to your `.gitignore` file and recommit/push your code.  
  Azure will create its own environment and install dependencies from `requirements.txt`.

---

## Best Practices

- **Use `requirements.txt`**: Always use `pip freeze > requirements.txt` to manage dependencies.
- **Virtual Environments**: Always develop within a virtual environment.
- **Gunicorn for Production**: Always use a WSGI server like Gunicorn for production deployments on App Service. Do not rely on `app.run()` as shown in development tutorials.
- **Environment Variables for Secrets**: Never hardcode sensitive information (API keys, database passwords) directly in your code. Use Azure App Service Application Settings (environment variables) to store them.
- **Logging**: Enable application logging and monitor your logs regularly.
- **Monitoring**: Use Azure Monitor to set up alerts and dashboards for your web app's performance and health.
- **Deployment Slots**: For production applications, use deployment slots to deploy new versions to a staging environment first, test thoroughly, and then swap with the production slot, ensuring zero downtime.
- **Resource Group Strategy**: Organize your Azure resources into logical resource groups.

---

By following these steps, you should be able to successfully deploy and manage your Python web application on Azure App Service.
