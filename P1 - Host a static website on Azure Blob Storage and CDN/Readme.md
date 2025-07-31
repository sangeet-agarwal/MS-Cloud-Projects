# Guide: Host a Static Website on Azure Blob Storage and CDN

This guide provides a complete walkthrough for hosting a static website on Azure, from creating the sample files to deploying and distributing them globally with a CDN.

---

## Part 1: Your Static Website Code

First, you'll need the website files. Create three files on your computer named `index.html`, `style.css`, and `script.js` and paste the code below into them.

### `index.html`
This file is the main structure of your website.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alex Doe ' Personal Portfolio</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>Alex Doe</h1>
        <p>Web Developer & Cloud Enthusiast</p>
    </header>

    <main>
        <section id="about">
            <h2>About Me</h2>
            <p>Welcome to my corner of the web! This is a simple static site hosted on <strong>Azure Blob Storage</strong> and delivered globally via <strong>Azure CNe</strong>. I'm passionate about building scalable and efficient web solutions.</p>
        </section>

        <section id="projects">
            <h2>My Projects</h2>
            <div class="project-card">
                <h3>Project Alpha</h3>
                <p>A description of the first amazo project.</p>
            </div>
            <div class="project-card">
                <h3>Project Beta</h3>
                <p>A description of the second incredible project.</p>
            </div>
        </section>
    </main>

    <footer>
        <button id="contactBtn">Contact Me</button>
        <p>&copy; 2025 Alex Doe</p>
    </footer>

    <script src="script.js"></script>
</body>
</html>
```

### `style.css`
This file adds styling to make your website look good.

```c\n
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
    color: #333;
    display: flex;
    flex-direction: column;
    align-items: center;
}

header {
    background-color: #0078D4;
    color: #fff;
    padding: 2rem 1rem;
    text-align: center;
    width: 100%;
}

header h1 {
    margin: 0;
    font-size: 2.5rem;
}

main {
    width: 90%;
    max-width: 800px;
    margin: 2rem 0;
}

section {
    background: #fff;
    padding: 1.5rem;
    margin-bottom: 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.project-card {
    border-left: 4px solid #0078D4;
    padding-left: 1rem;
    margin-top: 1rem;
}

footer {
    text-align: center;
    padding: 1rem;
    width: 100%;
}

button {
    background-color: #0078D4;
    color: white;
    border: none;
    padding: 10px 20px;
    font-size: 1rem;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #005a9e;
}
```

### `script.js`
This file adds simple interactivity.
```js
document.addEventListener('DOMContentLoaded', () => {
    const contactButton = document.getElementById('contactBtn');

    if (contactButton) {
        contactButton.addEventListener('click', () => {
            alert('Thanks for your interest! You can reach me at alex.doe@email.com.');
        });
    }
});
```

## Part 2: Step-by-Step Azure Hosting Process
Follow these steps to get your site live. You'll need an active Azure subscription to begin.

---
## Step 1: Create a Storage Account
Your website files will live inside an Azure Storage Account.

1.  Sign in to the Azure Portal.
2.  Click `+ Create a resource`. Search for `Storage Account` and click `Create`.
3.  On the **Basics** tab:
    * **Subscription**: Choose your Azure subscription.
    * **Resource group**: Click `Create new` and give it a name like `MyStaticSiteRG`.
    * **Storage account name**: Enter a globally unique, lowercase name (e.g., `youruniquenameportfolio`).
    * **Region**: Choose a region close to you (e.g., `(US) East US`).
    * **Performance**: Select `Standard`.
    * **Redundancy**: Select `Locally-redundant storage (LRS)` for the lowest cost.
4.  Click `Review + create` and then `Create`. Wait for the deployment to finish.

---
## Step 2: Enable Static Website Hosting
Now, you'll configure the storage account to serve web content.

1.  Once your storage account is created, click **Go to resource**.
2.  In the left-hand menu, scroll down to the **Data management** section and click on **Static website**.
3.  Toggle the status to **Enabled**.
4.  For the **Index document name**, enter `index.html`.
5.  Leave the **Error document path** blank for now.
6.  Click **Save**.
7.  Azure will now display a **Primary endpoint URL**. Copy this URL and save it. This is the direct link to your website on Blob Storage. It will look something like `https://youruniquenameportfolio.z13.web.core.windows.net/`.

---
## Step 3: Upload Your Website Files
1.  In the left-hand menu, under **Data storage**, click on **Containers**.
2.  You will see a new container named `$web`. This was created automatically when you enabled the static website feature. Click on it.
3.  Click the **Upload** button.
4.  In the panel that opens, click the folder icon to browse for your files. Select the `index.html`, `style.css`, and `script.js` files you created earlier.
5.  Click **Upload**.

>  **Checkpoint:** Your site is now live! Paste the **Primary endpoint URL** you copied earlier into your browser. You should see your portfolio website. The next step will make it faster using a CDN.

---
## Step 4: Set Up the Azure CDN
A Content Delivery Network (CDN) will cache your website at edge locations around the world, making it load faster for all users.

1.  In the Azure Portal, click `+ Create a resource`. Search for `Front Door and CDN profiles` and click `Create`.
2.  Select **Explore other offerings** and then choose **Azure CDN Standard from Microsoft (classic)**. Click **Continue**.
3.  On the **Basics** tab:
    * **Name**: Give your CDN profile a name, like `my-portfolio-cdn`.
    * **Resource Group**: Select the same resource group you created earlier (`MyStaticSiteRG`).
    * **Pricing tier**: Select `Standard Microsoft`.
4.  Click `Review + create` and then `Create`.
5.  After the CDN profile is deployed, go to the resource.
6.  Click `+ Endpoint`.
7.  In the "Add an endpoint" panel:
    * **Name**: Give the endpoint a globally unique name. This becomes part of your URL (e.g., `my-portfolio-site`). The full URL will be `my-portfolio-site.azureedge.net`.
    * **Origin type**: Select `Storage static website`.
    * **Origin hostname**: A dropdown will appear. Select your storage account's static website endpoint (it will have `web.core.windows.net` in the name).
8.  Click **Add**.

>  **Patience is key:** CDN endpoint propagation can take several minutes (sometimes up to 10-15 minutes).

---
## Step 5: Test Your CDN Link
1.  Once the endpoint status shows as "Running" (you may need to refresh), copy the **Endpoint hostname** (e.g., `https://my-portfolio-site.azureedge.net`).
2.  Paste this new URL into your browser. You should see the exact same website, but this time it's being served from the super-fast Azure CDN!

---
## Part 3: Technical Explanation of the Flow
Here’s a breakdown of what happens when a user visits your new CDN-powered website.

1.  **User Request**: A user enters your CDN URL (`https://my-portfolio-site.azureedge.net`) into their browser. The request is routed to the nearest Azure CDN Point of Presence (POP), which is a data center geographically close to the user.
2.  **CDN Cache Check**: The CDN POP checks its local cache for the requested files (`index.html`, `style.css`, etc.).
3.  **Cache Hit (Fast)**: If the files are in the cache and haven't expired, the CDN immediately serves them to the user. This is extremely fast because the data travels a very short physical distance.
4.  **Cache Miss (First Time)**: If this is the first time the file is requested from this POP (or the cached version has expired), the CDN forwards the request to the **Origin**.
5.  **Origin Request**: The **Origin** is the source of truth for your content. In this project, the origin is the **Static Website endpoint** of your Azure Blob Storage account (`https://...web.core.windows.net/`).
6.  **Blob Storage Serves Content**: Azure Storage receives the request and retrieves the appropriate file (e.g., `index.html`) from the special `$web` container.
7.  **Response and Caching**: The file is sent back from Blob Storage to the CDN POP. The POP then does two things:
    * It serves the file to the user's browser.
    * It stores a copy of the file in its cache for future requests to that same location.

This architecture is highly efficient. The slow trip to the origin server only happens on the first request from any given region. All subsequent requests are handled rapidly by the much closer CDN edge servers, providing a great user experience and reducing load on the storage account.
