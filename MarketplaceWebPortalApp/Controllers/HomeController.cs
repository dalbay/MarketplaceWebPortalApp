<li>
	<script>
		$(function () {
			$("#slider-range-diameter").slider({
				range: true,
				min: 0,
				max: 500,
				values: [0, 500],
				slide: function (event, ui) {
					$("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
				}
			});
			$("#amountMinDiameter").val("$" + $("#slider-range-diameter").slider("values", 0)),
				$("#amountMaxDiameter").val("$" + $("#slider-range-diameter").slider("values", 1));
		});
	</script>

	<p>
		<i style="margin-right:10px;" class="fas fa-long-arrow-alt-up">&#xf309;</i>
		<label for="amount">
			Airflow(CFM)
		</label>
	</p>
	<div class="row">
		<div class="col-md-3">
			<input type="text" class="sliderValue" id="amountMinDiameter" readonly />
		</div>
		<div id="slider-range-diameter" class="col-md-6  sliderBox"></div>
		<div class="col-md-2">
			<input type="text" class="sliderValue" id="amountMaxDiameter" readonly>
		</div>
	</div>
</li>