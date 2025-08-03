# Project 4: Implementing Basic Identity Management with Microsoft Entra ID

## Real-World Problem Scenario

A newly established company needs a centralized and secure system to manage user identities and provide single sign-on (SSO) capabilities for its growing suite of cloud applications. The goal is to simplify user access while enhancing overall security.

## Why This Matters & Our Architectural Approach

### Problem

In the absence of a centralized identity solution, users often have to manage separate accounts and passwords for each application, leading to password fatigue, increased support calls for forgotten credentials, and a higher risk of security vulnerabilities (e.g., weak or reused passwords). For IT administrators, managing disparate user directories across multiple applications is inefficient and prone to errors.

### Why This Way

Microsoft Entra ID (formerly Azure AD) is a cloud-based identity and access management (IAM) service that provides a unified solution for managing user identities, enabling single sign-on (SSO), and enforcing multi-factor authentication (MFA) across cloud and on-premises applications.

This project establishes identity as the foundational security perimeter for cloud resources, representing a significant paradigm shift in cloud security. By centralizing identity, organizations can simplify the user experience while simultaneously enhancing security through consistent policy enforcement, conditional access, and robust authentication mechanisms.

## Azure Services Involved

- Microsoft Entra ID (Azure AD)

## Step-by-Step Implementation Guide


---

## 🚀 Step 1: Set up the Project in VS Code

### Prerequisites

- **.NET SDK**: Ensure you have the .NET 6 (or later) SDK installed.
- **Visual Studio Code**: You should have VS Code installed with the C# Dev Kit extension.

### Instructions

1. Open VS Code and launch the Integrated Terminal (`Terminal > New Terminal`).
2. Run the following command to create a new Razor Pages project:

```bash
dotnet new webapp -n MyEntraWebApp
```

3. Open the newly created `MyEntraWebApp` folder in VS Code (`File > Open Folder...`).
4. In the Integrated Terminal, install the required NuGet packages:

```bash
dotnet add package Microsoft.Identity.Web
dotnet add package Microsoft.Identity.Web.UI
```

---

## 📝 Step 2: Configure the Web App Files

### `Program.cs`

This file configures the web application's services and request pipeline.

```csharp

using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddMicrosoftIdentityWebAppAuthentication(builder.Configuration, "AzureAd");

builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = options.DefaultPolicy;
});

builder.Services.AddRazorPages()
    .AddMvcOptions(options =>
    {
        var policy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();
        options.Filters.Add(new AuthorizeFilter(policy));
    })
    .AddMicrosoftIdentityUI();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapRazorPages();
app.MapControllers();

app.Run();
```

---

### `appsettings.json`

This file holds the configuration settings for the app. You must update the `TenantId` and `ClientId` placeholders.

```json

{
  "AzureAd": {
    "Instance": "https://login.microsoftonline.com/",
    "TenantId": "[Enter_your_tenant_id_here]",
    "ClientId": "[Enter_your_client_id_here]",
    "CallbackPath": "/signin-oidc",
    "SignedOutCallbackPath": "/signout-oidc"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

---

### `Pages/Shared/_Layout.cshtml`

```html
<!-- Pages/Shared/_Layout.cshtml -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>@ViewData["Title"] - MyEntraWebApp</title>
    <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="~/css/site.css" asp-append-version="true" />
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-sm navbar-light bg-white border-bottom box-shadow mb-3">
            <div class="container">
                <a class="navbar-brand" asp-area="" asp-page="/Index">MyEntraWebApp</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target=".navbar-collapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="navbar-collapse collapse d-sm-inline-flex justify-content-between">
                    <ul class="navbar-nav flex-grow-1">
                        <li class="nav-item"><a class="nav-link text-dark" asp-page="/Index">Home</a></li>
                        <li class="nav-item"><a class="nav-link text-dark" asp-page="/Privacy">Privacy</a></li>
                        <li class="nav-item"><a class="nav-link text-dark" asp-page="/Secure">Secure Page</a></li>
                    </ul>
                    <partial name="_LoginPartial" />
                </div>
            </div>
        </nav>
    </header>
    <div class="container">
        <main role="main" class="pb-3">
            @RenderBody()
        </main>
    </div>
    <footer class="border-top footer text-muted">
        <div class="container">
            &copy; 2024 - MyEntraWebApp - <a asp-page="/Privacy">Privacy</a>
        </div>
    </footer>
    <script src="~/lib/jquery/dist/jquery.min.js"></script>
    <script src="~/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="~/js/site.js" asp-append-version="true"></script>
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

---

### `Pages/Secure.cshtml.cs`

```csharp
// Pages/Secure.cshtml.cs

using Microsoft.AspNetCore.Mvc.RazorPages;

namespace MyEntraWebApp.Pages;

public class SecureModel : PageModel
{
    private readonly ILogger<SecureModel> _logger;

    public SecureModel(ILogger<SecureModel> logger)
    {
        _logger = logger;
    }

    public void OnGet()
    {
        // This page is protected by the [Authorize] attribute.
    }
}
```

---

### `Pages/Secure.cshtml`

```html

@page
@model MyEntraWebApp.Pages.SecureModel
@{
    ViewData["Title"] = "Secure Page";
}

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>@ViewData["Title"]</h1>
            <p>Welcome to the secure area! You must be logged in to view this page.</p>

            <h2>Your Claims</h2>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Claim Type</th>
                        <th>Claim Value</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach (var claim in User.Claims)
                    {
                        <tr>
                            <td>@claim.Type</td>
                            <td>@claim.Value</td>
                        </tr>
                    }
                </tbody>
            </table>
        </div>
    </div>
</div>
```

---

### `Pages/_LoginPartial.cshtml`

```html
<!-- Pages/_LoginPartial.cshtml -->

@using System.Security.Claims
@using Microsoft.Identity.Web

<ul class="navbar-nav">
    @if (User.Identity.IsAuthenticated)
    {
        <li class="nav-item">
            <span class="navbar-text text-dark">Hello @User.Identity.Name!</span>
        </li>
        <li class="nav-item">
            <a class="nav-link text-dark" asp-controller="Account" asp-action="SignOut">Sign out</a>
        </li>
    }
    else
    {
        <li class="nav-item">
            <a class="nav-link text-dark" asp-controller="Account" asp-action="SignIn">Sign in</a>
        </li>
    }
</ul>
```

---

### `Pages/Privacy.cshtml`

```html

@page
@model PrivacyModel
@{
    ViewData["Title"] = "Privacy Policy";
}
<h1>@ViewData["Title"]</h1>
<p>Use this page to detail your site's privacy policy.</p>
```

---

### `Pages/Index.cshtml`

```html

@page
@model IndexModel
@{
    ViewData["Title"] = "Home page";
}

<div class="text-center">
    <h1 class="display-4">Welcome</h1>
    <p>This is a simple web app to demonstrate identity management with Microsoft Entra ID.</p>
</div>
```

---

## 🏗️ Step 3: Configure Microsoft Entra ID App Registration

- **Find your Tenant ID**: Azure Portal > Microsoft Entra ID > Overview
- **Find your Client ID**: Microsoft Entra ID > App registrations > MyEntraWebApp
- **Configure Redirect URIs**:
  - `https://<your-webapp-name>.azurewebsites.net/signin-oidc`
  - `http://localhost:<port>/signin-oidc`
- **Enable ID Tokens**: Authentication blade > check "ID tokens"
- **Configure API Permissions**: Add `User.Read` and grant admin consent
- **Assign AppUsers group**: Enterprise applications > MyEntraWebApp > Users and groups

---

## 🔧 Step 4: Run and Deploy the Application

### Local Testing

```bash
dotnet run
```

- Navigate to the output URL (e.g., `https://localhost:5225`)

### Deployment to Azure

1. Install **Azure App Service** extension in VS Code
2. Sign in to Azure
3. Right-click your project folder > **Deploy to Web App**
4. Select your subscription and App Service
5. Confirm deployment and monitor the output

---

## Common Errors and Solutions

- **ArgumentNullException: 'ClientId' must be provided**  
  → Replace the `[Enter_your_client_id_here]` placeholder in `appsettings.json`.

- **AADSTS700054: response_type 'id_token' not enabled**  
  → Go to App Registration > Authentication > Enable ID tokens.

- **AADSTS50011: redirect URI mismatch**  
  → Ensure the URI is added in the App Registration > Authentication.

- **Permission denied to view page**  
  → Ensure `Program.cs` includes `app.MapRazorPages();`, redeploy, or add `Index.cshtml` to App Service default docs.
