<template>
	<div>
		<div :style="{flexDirection:direction, alignItems:items, width:width, height:height, justifyContent:content}">
			<div v-for="({englishName, tabName, mUrl, textColor, font}, index) in tabModels" class="show">
				<div class="space"></div>
				<text :style="{fontSize: font, color: textColor}" @click="onClick($event, index)">{{tabName}}</text>
				<div class="space"></div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.show
{
  flex-direction:row;
  align-items:center;
  justify-content:center;
}
.space
{
  width:10px;
}
</style>

<script>
var nativeEventHandle = require('@jud-module/nativeEventHandle');
var globalEvent = jud.requireModule('globalEvent');
export default{
	data:{
		tabModels:[],
		lastTab: 0,
		bColor: "#FF0000",
		align:"center",
		direction:"row",
	  	alignItems:"center",
	  	width: "1024px",
	  	height: "55px",
	  	content:"center"
	},
	created()
		{
			var self = this;
			globalEvent.addEventListener("judLoadTabData", function (info) {
  				self.setupTabModels(info["data"]);
			});

			globalEvent.addEventListener("JDProductIntroduceSegmentViewControllerRotate", function (info) {
  				var rotate = info["rotate"];
  				if(rotate == 0)
  				{
  					self.width = "1024px";
  				}
  				else
  				{
  					self.width = "768px";
  				}
			});

			self.width = jud.config.deviceWidth;
		},
	methods:{
		setupTabModels(array){
			
			for (let i = 0; i < array.length; i++) {
	        	var info = array[i];
	        	info["font"] = "14px";
	        	if(i == 0)
	        	{
	        		info["textColor"] = "#f4211b";
	        	}
	        	else
	        	{
	        		info["textColor"] = "#999999";
	        	}
	      	}

			this.tabModels = array;
			this.selectTabAtIndex(0);
		},
		onClick(event, index)
		{
			this.selectTabAtIndex(index);
		},
		selectTabAtIndex(index)
		{
			var lastInfo = this.tabModels[this.lastTab];
			lastInfo["textColor"] = "#999999";
			var info = this.tabModels[index];
			info["textColor"] = "#f4211b";
			this.lastTab = index;

			var self = this;

            nativeEventHandle.handleEvent(
            	"JDProductIntroduceSegmentViewController",
            	{"index": index}, 
            	function(ret) {
        		});
		}
	}
}
</script>>