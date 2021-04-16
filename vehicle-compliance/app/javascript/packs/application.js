// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();

import '../styles/application.scss';
import '../src/GovUKAssets';
import { initAll } from 'govuk-frontend/govuk/all.js';
import initPrintLink from '../src/printLink/init';
import cookieControl from "../src/cookieControl";
import backLink from "../src/backLink";

document.body.classList.add('js-enabled');

initAll();
initPrintLink();
cookieControl();
backLink();
