// Load jquery and js only on `app/views/air_zones/compliance.html.haml` page
require('jquery')
import MOJFrontend from "@ministryofjustice/frontend/moj/all.js";

document.addEventListener('DOMContentLoaded', () => {
  new MOJFrontend.SortableTable({
    table: [
      $('table')[0]
    ]
  });
});
