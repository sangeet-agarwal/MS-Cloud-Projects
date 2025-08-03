// Pages/Secure.cshtml.cs
// The C# code-behind for the secure page.

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
        // It will only be accessible if the user is authenticated.
    }
}
