{TITLE}

{+START,IF_PASSED,GENERATED}
	<div class="filedump_generated">
		{+START,IF_PASSED,RENDERED}
			<div class="filedump_generated_preview">
				<span class="lonely_label">{!PREVIEW}:</span>
				{RENDERED}
				<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean auctor nisi non turpis tincidunt vestibulum. Praesent vitae mollis elit. Vestibulum luctus velit urna, et congue justo dapibus id. Nullam in eros ac libero rutrum accumsan in ac mauris.</p>
				<p>Vestibulum orci sem, dictum ut turpis ut, congue varius lorem. Nam eleifend sollicitudin vestibulum. Aliquam erat volutpat. Ut fermentum sodales risus, at ullamcorper sem egestas sed. In interdum lobortis est. Sed rutrum, ligula et luctus scelerisque, libero magna malesuada enim, quis semper lorem eros vel eros.</p>
			</div>
		{+END}

		<div class="filedump_generated_comcode">
			<label for="generated_comcode" class="lonely_label">{!_COMCODE}:</label>
			<form action="#" method="post" autocomplete="off">
				<div>
					<textarea id="generated_comcode" name="generated_comcode" cols="50" rows="10">{GENERATED*}</textarea>
				</div>
			</form>
		</div>
	</div>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			var e=document.getElementById('generated_comcode');
			try
			{
				e.focus();
			}
			catch (e) {}
			e.select();
		});
	//]]></script>
{+END}

{+START,IF_NON_PASSED,GENERATED}
	<p>
		{!FILEDUMP_EXISTING_COUNT,{$NUMBER_FORMAT,{EXISTING_COUNT}}}
	</p>

	<div class="filedump_image_sizes">
		<p class="lonely_label">
			{!FILEDUMP_IMAGE_URLS}:
		</p>
		<ul class="compact_list image_sizes">
			{+START,LOOP,IMAGE_SIZES}
				<li>
					<label for="img_size_{SIZE_WIDTH*}">{LABEL*}</label>
					<input onclick="this.select();" type="text" size="{$?,{$MOBILE},32,80}" id="img_size_{SIZE_WIDTH*}" name="img_size_{SIZE_WIDTH*}" value="{SIZE_URL*}" />
					<span class="associated_details">(<a rel="lightbox" href="{SIZE_URL*}">{!PREVIEW}</a>)</span>
				</li>
			{+END}
		</ul>

		<h2>{!_COMCODE}</h2>
	</div>
{+END}

{FORM}
