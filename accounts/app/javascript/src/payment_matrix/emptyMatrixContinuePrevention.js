export default function () {
  refereshContinueButtonDisability();
  attachRecalculationToCheckboxes();
}

function attachRecalculationToCheckboxes() {
  var allCheckboxes = document.getElementsByClassName('govuk-checkboxes__input');

  for(var checkbox of allCheckboxes) {
    checkbox.addEventListener("click", (e) => { recalculateAllCheckedCheckboxesCount(e.target) });
  }
}

function recalculateAllCheckedCheckboxesCount(target) {
  var allSelectedCheckboxesCountInput = document.getElementById('allSelectedCheckboxesCount');
  var allSelectedCheckboxesCount = parseInt(allSelectedCheckboxesCountInput.value);

  if(target.checked) {
    allSelectedCheckboxesCount++;
  } else {
    allSelectedCheckboxesCount--;
  }

  allSelectedCheckboxesCountInput.value = allSelectedCheckboxesCount;
  refereshContinueButtonDisability()
}

function refereshContinueButtonDisability() {
  var allSelectedCheckboxesCount = document.getElementById('allSelectedCheckboxesCount');
  var continueButton = document.getElementById('continue-matrix-button');

  if (continueButton != null) {
    continueButton.disabled = parseInt(allSelectedCheckboxesCount.value) == 0;
  }
}
