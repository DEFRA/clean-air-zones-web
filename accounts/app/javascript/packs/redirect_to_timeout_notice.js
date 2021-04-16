const redirectToTimeoutNoticeData = document.getElementById("redirect_to_timeout_notice_data");
const timeoutTimeInMinutes = redirectToTimeoutNoticeData.getAttribute("timeout_time");
const logoutNoticePath = redirectToTimeoutNoticeData.getAttribute("logout_notice_path");
const redirectTimeInMinutes = timeoutTimeInMinutes - 1;
const timeOffset = 1000 * 60 * redirectTimeInMinutes;

setTimeout(function(path) {
  const xmlhttp = new XMLHttpRequest();
  const payload = JSON.stringify({ "logout_notice_back_url": window.location.href });

  // Request sends the current url to be stored in session. When user will click 'continue'
  // on the logout_notice_path, he will be taken back to the URL provided here.
  xmlhttp.open('POST', '/assign_logout_notice_back_url');
  xmlhttp.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
  xmlhttp.send(payload);

  xmlhttp.onreadystatechange = function() {
    // When request is successful, user is redirected to the logout_notice_path.
    if (xmlhttp.readyState == 4 && xmlhttp.status == 204) {
      window.location.replace(path);
    }
  }

}, timeOffset, logoutNoticePath);
