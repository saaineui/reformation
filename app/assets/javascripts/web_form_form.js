(function(){
  function toggle_disabled_on_row(){
    var marked_for_deletion = $(this).prop('checked');
    
    $(this)
      .parent().parent()
      .prev().prev()
      .children('input')
      .prop('disabled', marked_for_deletion);
    
    $(this)
      .parent().parent().parent()
      .toggleClass('has-error');
  }
  
  function confirm_delete_checked(e){
    var num_marked_for_deletion = $('.toggle-disable:checked').length;
    
    if (num_marked_for_deletion > 0) {
      return window.confirm(num_marked_for_deletion + ' field(s) and their data will be deleted forever. Are you sure?');
    }
    return true;
  }
  
  
    $().ready(function(){
      $('.toggle-disable').click(toggle_disabled_on_row);
      $('.edit_web_form').submit(confirm_delete_checked);
    });
})();
