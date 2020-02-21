      $(document).ready(function () {
          document.getElementById('improvements_disable_id_tracker_link').setAttribute('href', '/id_tracker/add/' + document.getElementById('settings_improvements_disable_id_tracker_selected').value);
          document.getElementById('settings_improvements_disable_id_tracker_selected').setAttribute('onclick', 'id_tracker()');
      });

      function id_tracker() {
          document.getElementById('improvements_disable_id_tracker_link').setAttribute('href', '/id_tracker/add/' + document.getElementById('settings_improvements_disable_id_tracker_selected').value);
      }