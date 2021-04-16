// Load js only on `app/views/vehicles/export.html.haml` page

// Reveals download in progress message
var btn = document.getElementById('export-button');
btn.addEventListener('click', () => {
  var download_in_progress_message = document.getElementById('download_message');
  download_in_progress_message.style.display = "block";
  btn.className = 'govuk-button govuk-button--disabled';
  setTimeout(function() {
    btn.className = 'govuk-button';
    download_in_progress_message.style.display = "none";
  }, 5000);
});

