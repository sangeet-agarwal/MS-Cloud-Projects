document.addEventListener('DOMContentLoaded', () => {
    const contactButton = document.getElementById('contactBtn');

    if (contactButton) {
        contactButton.addEventListener('click', () => {
            alert('Thanks for your interest! You can reach me at alex.doe@email.com.');
        });
    }
});
