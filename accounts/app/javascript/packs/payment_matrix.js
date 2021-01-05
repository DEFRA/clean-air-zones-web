import "core-js/stable";
import "regenerator-runtime/runtime";
import initSearch from "../src/payment_matrix/initSearch";
import initPaginationButton from "../src/payment_matrix/initPaginationButton";
import preventContinue from "../src/payment_matrix/emptyMatrixContinuePrevention";

window.addEventListener("DOMContentLoaded", () => {
  preventContinue();
  initSearch();
  ["next", "previous"].forEach((direction) => initPaginationButton(direction));
});
