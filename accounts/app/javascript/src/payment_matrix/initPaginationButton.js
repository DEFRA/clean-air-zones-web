import submitForm from "./submitForm";

export default function (page) {
  const form = document.getElementById("payment-form");

  const paginationButton = document.getElementById(`pagination-button-${page}`);
  if (paginationButton) {
    paginationButton.addEventListener("click", (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }

  const paginationButtonPrevious = document.getElementById(`pagination-button-previous`);
  if (paginationButtonPrevious) {
    paginationButtonPrevious.addEventListener("click", (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }

  const paginationButtonNext = document.getElementById(`pagination-button-next`);
  if (paginationButtonNext) {
    paginationButtonNext.addEventListener("click", (e) => {
      form.appendChild(addPageNumber(page));
      submitForm(e, form);
    });
  }
}

function addPageNumber(page) {
  const input = document.createElement("input");
  input.type = "hidden";
  input.name = "commit";
  input.value = page;
  return input;
}
