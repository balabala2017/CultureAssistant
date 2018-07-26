function img_replace(source, replaceSource) {
    $('img[zhimg-src*="'+source+'"]').each(function () {
        $(this).attr('src', replaceSource);
    });
}

function img_replace_by_url(url) {
	var objs = document.getElementsByTagName("img"); 

	for(var i=0;i<objs.length;i++) {
		var imgSrc = objs[i].getAttribute("src_link");     
		var imgOriSrc = objs[i].getAttribute("ori_link");  
		if(imgOriSrc == url) {  
   			objs[i].setAttribute("src",imgSrc);
		}	
	}
}

function img_replace_all() {
	
	var result = '';
	
	var objs = document.getElementsByTagName("img"); 
	for(var i=0;i<objs.length;i++) {    
		var imgSrc = objs[i].getAttribute("src_link");     
		objs[i].setAttribute("src", imgSrc );
		
		result = result + imgSrc;
		result = result + ","; 
	}
	
	return result;
}

function getH(){

	if(window.injectedObject){
		injectedObject.onScrollHeight(document.body.scrollHeight);
	}
}

function openImage(url) {
	
	if(window.injectedObject){
		injectedObject.openImage(url);
	}
}

function openVideo(url) {
	
	if(window.injectedObject){
		injectedObject.openVideo(url);
	}
}

function voteSubmit(){

	var votes = new Array();
	
	var toupiaoIndex = 0;
	var itemIndex = 0;
	var cToupiaoIndex = 0;
	
	var inputElements = document.getElementsByTagName("input"); 
	
	for(var i=0;i<inputElements.length;i++) {    
		
		var type = inputElements[i].getAttribute("type");     
		
		if(type=="hidden"){

			var id = inputElements[i].getAttribute("value");
			
			itemIndex = 0;
			
			var vote = new Object();
			vote.id = id;
			var itemIds = new Array();
			vote.itemIds = itemIds;
			
			votes.push(vote);
			
			cToupiaoIndex = toupiaoIndex++;
			
		}else if(type=="radio"){
					
			if(inputElements[i].checked){
				votes[cToupiaoIndex].itemIds[itemIndex++] = inputElements[i].getAttribute("value");
			}
			
		}else if(type=="checkbox"){
			if(inputElements[i].checked){
				votes[cToupiaoIndex].itemIds[itemIndex++] = inputElements[i].getAttribute("value");
			}
		}
		
	}
	
//	if(window.injectedObject){
//		injectedObject.voteSubmit(JSON.stringify(votes));
//	}
    document.location="myjsweb://com.tianwen.jjrb?result="+JSON.stringify(votes);

}


function voteComplete(data){
	
	var data = $.parseJSON(data);
	//如果投票成功
	if(data.resultCode==200){
        for(var i=0;i<data.rows.length;i++){
            if(i==0){
                if(data.rows[i].type=='single'){
                    if(data.rows.length==1){
           	 			var strlabel='<strong><label style="font-size:16px;">'+data.rows[i].title+'(单选)</label></strong>';
                    }else{
                    	var strlabel='<strong>'+(i+1)+'、<label style="font-size:16px;">'+data.rows[i].title+'(单选)</label></strong>';
                    }
                }else{
                	if(data.rows.length==1){
                		var strlabel='<strong><label style="font-size:16px;">'+data.rows[i].title+'(多选)</label></strong>';
                	}else{
                		var strlabel='<strong>'+(i+1)+'、<label style="font-size:16px;">'+data.rows[i].title+'(多选)</label></strong>';
                	}
                }
           	 if(data.rows[i].iterm3!=null && data.rows[i].iterm4==null && data.rows[i].iterm5==null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}]);
                 }else if(data.rows[i].iterm4!=null && data.rows[i].iterm5==null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"}]); 
                 }else if(data.rows[i].iterm5!=null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm6!=null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"},{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm7!=null && data.rows[i].iterm8==null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"},{"name":data.rows[i].iterm7,"data":data.rows[i].iterm7Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm8!=null){
                	$("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"},{"name":data.rows[i].iterm7,"data":data.rows[i].iterm7Number,"color":"#39c"},{"name":data.rows[i].iterm8,"data":data.rows[i].iterm8Number,"color":"#39c"}]);  
                 }
                 else{
                	 $("#voteQuestion").study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"}]);
                 }
            	 $("#voteQuestion").before(strlabel);	                                           	
            }else{
           	 var str='<div id="voteQuestion'+i+'"></div>';
           	if(data.rows[i].type=='single'){
           	 	var str1='<strong>'+(i+1)+'、<label style="font-size:16px;">'+data.rows[i].title+'(单选)</label></strong>';
           	}else{
           		var str1='<strong>'+(i+1)+'、<label style="font-size:16px;">'+data.rows[i].title+'(多选)</label></strong>';
           	}
           	 if(i>=2){
             	 	$("#voteQuestion"+(i-1)).after(str);
             	 	$("#voteQuestion"+(i-1)).after(str1);
           	 }else{
           		 $("#voteQuestion").after(str);
           		 $("#voteQuestion").after(str1);
           	 }
                 $('#form1').remove();
                 if(data.rows[i].iterm3!=null && data.rows[i].iterm4==null && data.rows[i].iterm5==null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}]);
                 }else if(data.rows[i].iterm4!=null && data.rows[i].iterm5==null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"}]); 
                 }else if(data.rows[i].iterm5!=null && data.rows[i].iterm6==null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm6!=null && data.rows[i].iterm7==null && data.rows[i].iterm8==null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"},{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm7!=null && data.rows[i].iterm8==null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"},{"name":data.rows[i].iterm7,"data":data.rows[i].iterm7Number,"color":"#39c"}]);  
                 }else if(data.rows[i].iterm8!=null){
                	$("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"},{"name":data.rows[i].iterm3,"data":data.rows[i].iterm3Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm4,"data":data.rows[i].iterm4Number,"color":"#39c"},{"name":data.rows[i].iterm5,"data":data.rows[i].iterm5Number,"color":"#39c"}
                	,{"name":data.rows[i].iterm6,"data":data.rows[i].iterm6Number,"color":"#39c"},{"name":data.rows[i].iterm7,"data":data.rows[i].iterm7Number,"color":"#39c"},{"name":data.rows[i].iterm8,"data":data.rows[i].iterm8Number,"color":"#39c"}]);  
                 }
                 else{
                     $("#voteQuestion"+i).study_vote([{"name":data.rows[i].iterm1,"data":data.rows[i].iterm1Number,"color":"#39c"},{"name":data.rows[i].iterm2,"data":data.rows[i].iterm2Number,"color":"#39c"}]);                       	
                 }
            }
        }
        $("#submitVote").val("您已投票");
        $("#submitVote").css("background","#ccc");
        $("#submitVote").attr({"disabled":"disabled"});
    }
}

$.fn.study_vote= function(options,totle){
	var settings=options;
	if(totle!=null)
	{
		if(isNaN(totle))
		{
			alert('参数错误');
			return;
		}
	}
	if(typeof(settings)!='object')
	{
		alert('参数错误');
		return;
	}
	var container = jQuery(this);
	container.html('<dl id="studyvote"></dl>');
	var study_voteCount=0;
	if(totle==null||totle=='')
	{//单项投票
		for(i=0;i<settings.length;i++)
		{
			study_voteCount += parseInt(settings[i].data);
		}
	}
	else
	{//多项投票
		study_voteCount = parseInt(totle);
	}
	var study_votestr="";
		for(i=0;i<settings.length;i++)
		{
			var studyplay_present=settings[i].data/study_voteCount*100;
			if(parseInt(studyplay_present)!=studyplay_present)
			{
				studyplay_present=studyplay_present.toFixed(2);
			}
			study_votestr +='<dd class="dd"><div class="fl">'+settings[i].name+'</div></dd><div class="outbar"><div class="inbar" style="width:'+studyplay_present+'%;background:'+settings[i].color+';"></div></div> <div class="fl fl2">'+studyplay_present+'% </div>';
		}
	container.find('#studyvote').html(study_votestr)
}

function openWebView(url){
	
	if(window.injectedObject){
		injectedObject.openWebView(url);
	}
}
//对checkbox和radio进行背景替换
$(document).ready(function(){
		//对radio进行背景置换处理
    	$("input[type='radio']").each(function(index,item){
    		var parent=$(this).parent();
    		var text=parent.text();
    		var name=$(this).attr("name");
    		var html="<div class='radio radioSelect' name='"+name+"'>"+text+"</div>";
    		$(this).hide();//隐藏radio
    		var src=parent.html();
    		var ht	=src.replace(text.trim(),"");//隐藏后面的文字
    		parent.html(ht);
    		parent.append($(html));
    	});
    	//对checkbox进行背景置换处理
    	$("input[type='checkbox']").each(function(index,item){
    		var parent=$(this).parent();
    		var text=parent.text();
    		var html="<div class='check checkSelect'>"+text+"</div>";
    		$(this).hide();//隐藏radio
    		var src=parent.html();
    		var ht	=src.replace(text.trim(),"");//隐藏后面的文字
    		parent.html(ht);
    		parent.append($(html));
    	});
    	
    	//监听radio的click事件，radio需要根据name进行组的改变
    	$(".radioSelect").on("click",function(){
    		if($(this).hasClass("radio")){
    			var name=$(this).attr("name");
    			$("input[type='radio'][name='"+name+"']").removeAttr("checked");
    			$(".radioSelect[name='"+name+"']").removeClass("radioed").addClass("radio");
    			$(this).removeClass("radio");
    			$(this).addClass("radioed");
    			$(this).prev().attr("checked",true);
    		}else{
    			$(this).prev().removeAttr("checked");
    			$(this).removeClass("radioed");
    			$(this).addClass("radio");
    		}                    		
    	});
    	
    	//监听checkbox的click事件
    	$(".checkSelect").on("click",function(){
    		if($(this).hasClass("check")){
    			$(this).removeClass("check");
    			$(this).addClass("checked");
    			$(this).prev().attr("checked",true);
    		}else{
    			$(this).prev().removeAttr("checked");
    			$(this).removeClass("checked");
    			$(this).addClass("check");
    		}                    		
    	});
    });

function adjustImagePosition(){
    $("article").find("img").css("width","100%").css("max-width","98%").css("display", "block").css("margin"," 5px auto").css("border"," 1px solid #eee").css("padding", "2px");
}
