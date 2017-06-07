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
var communicate = jud.requireModule('communicate');
export default{
	created(){
		communicate.listen("START", function(info){
			console.log("communicate.listen: " + info);
		});
	},
	methods:
	{
		onClick()
		{
			communicate.send("HelloWorld", {"XYZ":"dsdad"}, function(info){
				console.log("communicate.send: " + info);
			});
		}
	}

}
</script>