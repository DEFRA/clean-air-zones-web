import createHiddenInput from "./createHiddenInput";

export default function (e, form) {
  e.preventDefault();
  disableButtons();

  const searchInput = document.getElementById("vrn-search");
  form.appendChild(createHiddenInput("payment[vrn_search]", searchInput.value));
  form.submit();
}

function disableButtons() {
  document
    .querySelectorAll("input[type=submit],input[type=button]")
    .forEach((button) => {
      button.disabled = true;
    });
  document.querySelectorAll("li.moj-pagination__item").forEach((li) => {
    li.classList.add("is-disabled");
  });
}
