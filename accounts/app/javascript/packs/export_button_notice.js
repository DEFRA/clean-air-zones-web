// Reveals download in progress message
const btn = document.getElementById("csv-export");
btn.addEventListener("click", () => {
  const message = document.getElementById("csv-export__notice");
  message.style.display = "block";
  btn.className = "govuk-link disabled-link";
  setTimeout(() => {
    btn.className = "govuk-link";
    message.style.display = "none";
  }, 5000);
});
