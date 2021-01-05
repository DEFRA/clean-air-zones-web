import createHiddenInput from "./createHiddenInput";
import submitForm from "./submitForm";

export default function (direction) {
  const form = document.getElementById("payment-form");
  const paginationButton = document.getElementById(
    `pagination-${direction}-link`
  );

  if (paginationButton) {
    paginationButton.addEventListener("click", (e) => {
      form.appendChild(createHiddenInput("commit", capitalize(direction)));
      submitForm(e, form);
    });
  }
}

function capitalize(string) {
  return string[0].toUpperCase() + string.slice(1);
}
