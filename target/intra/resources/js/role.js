/**
 * Role toggle — "admin" or "user"
 * Reads/writes to localStorage and applies .is-admin to <body>.
 * Must be loaded before DOMContentLoaded scripts that check role.
 */
(function () {
  var KEY = "kosep.eval.v1.role";

  function getRole() {
    return localStorage.getItem(KEY) === "admin" ? "admin" : "user";
  }

  function setRole(role) {
    localStorage.setItem(KEY, role);
    applyRole(role);
  }

  function applyRole(role) {
    if (role === "admin") {
      document.body.classList.add("is-admin");
    } else {
      document.body.classList.remove("is-admin");
    }
    /* sync all toggle buttons on the page */
    var btns = document.querySelectorAll(".role-btn");
    for (var i = 0; i < btns.length; i++) {
      var btn = btns[i];
      btn.classList.toggle(
        "role-btn--active",
        btn.getAttribute("data-role") === role
      );
    }
  }

  /* apply immediately (before paint) */
  applyRole(getRole());

  /* wire up buttons once DOM is ready */
  function bindButtons() {
    var btns = document.querySelectorAll(".role-btn");
    for (var i = 0; i < btns.length; i++) {
      (function (btn) {
        btn.addEventListener("click", function () {
          setRole(btn.getAttribute("data-role"));
        });
      })(btns[i]);
    }
    /* re-sync active state */
    applyRole(getRole());
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", bindButtons);
  } else {
    bindButtons();
  }

  window.RoleManager = { getRole: getRole, setRole: setRole };
})();
