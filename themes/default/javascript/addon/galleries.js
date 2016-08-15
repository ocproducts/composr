
// GALLERY_IMPORT_SCREEN:
function preview_generator_mouseover(event)
{
    if (typeof event=='undefined') event=window.event;
    if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'<img width="500" src="{$BASE_URL*}/uploads/galleries/'+window.encodeURI(this.value)+'" \/>','auto');
}

function preview_generator_mousemove(event)
{
    if (typeof event=='undefined') event=window.event;
    if (typeof window.activate_tooltip!='undefined') reposition_tooltip(this,event);
}

function preview_generator_mouseout(event)
{
    if (typeof event=='undefined') event=window.event;
    if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(this);
}

function load_previews()
{
    var files=document.getElementById('second_files');
    if (!files) return;
    for (var i=0;i<files.options.length;i++)
    {
        files[i].onmouseover=preview_generator_mouseover;
        files[i].onmousemove=preview_generator_mousemove;
        files[i].onmouseout=preview_generator_mouseout;
    }
}