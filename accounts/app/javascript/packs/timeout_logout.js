const timeoutLogoutData = document.getElementById('timeout_logout_data');
const timedoutUserPath = timeoutLogoutData.getAttribute('timedout_user_path');
var timeOffset = 1000 * 60; // 1 minute

setTimeout(function(path) {
  window.location.replace(path);
}, timeOffset, timedoutUserPath);
