<template>
  <div class='bg' @click="onClick">
  </div>
</template>

<style>
.bg
{
  background-color:red;
}
</style>

<script>
var mta = jud.requireModule('mta');
export default{
	methods:
	{
		onClick()
		{
			mta.page_id_param_event_id_param_next("XYZPage", "ID_1", "222", "HelloWorld", "ID_2", "666", "XYZPage2");
			mta.click("click_XYZPage", "click_ID_1", "click_222", "click_HelloWorld", "click_ID_2", "click_666", "click_XYZPage2");

			mta.name_id_param("pvXYZ", "222", "world");
			mta.pv("pv_pvXYZ", "pv_222", "pv_world");

			mta.level_name_event_other_param_params(1, "XYZPage", "LLL", "SSS", "ddd", {"Hello":"world"});
			mta.level(1, "level_XYZPage", "LLL", "SSS", "ddd", {"level_Hello":"world"});
		}
	}

}
</script>