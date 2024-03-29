// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import '../styles/application.scss';
import '../src/GovUKAssets';
import { initAll } from 'govuk-frontend/govuk/all.js';
import initPrintLink from '../src/printLink/init';
import cookieControl from "../src/cookieControl";
import initBackLink from '../src/backLink/init';
import '@fortawesome/fontawesome-free/css/regular.min.css';

document.body.classList.add('js-enabled');

initAll();
initPrintLink();
cookieControl();
initBackLink();
