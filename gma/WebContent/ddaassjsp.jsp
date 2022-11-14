<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동물원</title>
<script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
<link href="css/reset.css" rel="stylesheet">
<link href="css/lol.css" rel="stylesheet">
<link href="css/css.css" rel="stylesheet">

<script type="text/javascript">

var game_list=[],player_list=[],game_info_list=[];
//검색한 게임 아이디 리스트,검색한 게임에서 내 위치,검색한 게임 자체 배
var global_name="";
var global_targetid=-1;
var global_perks;
var global_puid;
var key="RGAPI-f7a95a2c-95a4-430a-9d57-b52238901aef";



$(function(){

	    let _width=screen.availWidth;
	    let _height=screen.availHeight/1.2;
	    $(`.top`).css("width",_width);
	    $(`body`).css("width",_width);
	    $(`body`).css("height",_height);
	    $(`.top`).css("height",_height);
	    $(`.game_main_in`).css("overflow-y","auto");
	    let _2width=$(".game_main").css("width");
	    let num=_2width.replace(/[^0-9]/g,'');
	    
	    grid_x=(num-64)*0.2;
	    
	     
	    let _2height=$(".game_main").css("height");
	    let num2=_2height.replace('px','');
	     grid_y=(num2-64)*0.2;
	     
	     scr_get_runes("12.21.1");
	     
	 });
 
$(document).on(`click`,`.DB .right_dd`,function(){
      
         
           let cla= $(this).parent().attr("class");
           let num=cla.replace(/[^0-9]/g,'');
          	
           $(`.num\${num}`).remove();
           obj_an_list.splice(num,1);
           
        for(let i=num;i<=obj_an_list.length;i++){
            let _target=$(`.num\${i}`);
            _target.removeClass(`num\${i}`);
            _target.addClass(`num\${i-1}`);
        }
        stopPropagation();

        
        


        });//
        
$(document).on(`click`,`.wjswjr`,function(){
			    global_targetid=$(this).find("input[type=hidden][name=gameid]").val();
			   let map=$(this).find("input[type=hidden][name=gamemap]").val();
			   let playid=$(this).find("input[name=num]").val();
			   let target=$(`.se_list .DB ul`);
			   let rune=player_list[playid].perks.styles[0];//가지고있는룬정보
			   let runeid=rune.style;//가지고있는 메인룬타입    
			   let rune_obj=new scr_get_info_rune(runeid);	
			    
	target.empty();
	target.append(`<li class=seli><div class="left_side "><img src="http://ddragon.leagueoflegends.com/cdn/img/\${rune_obj.img}" />\${rune_obj.name}</div></li>`);//데이터 베이스에 오브젝트 정보칸 추가
	

    for(var i=0;i<4;i++){
   	  rune_obj=new scr_get_info_rune(runeid,rune.selections[i].perk,i);//검사할 메인 룬 타입, 검사할 섹션, 그거 위치
   	  scr_create_object(rune_obj,target);
    }
	
	
    rune=player_list[playid].perks.styles[1];//가지고있는룬정보 
	runeid=rune.style;//가지고있는 서브룬타입
	rune_obj=new scr_get_info_rune(runeid);//서브룬정보 받아오기
	
	target.append(`<li class=seli><div class="left_side"><img src="http://ddragon.leagueoflegends.com/cdn/img/\${rune_obj.img}" />\${rune_obj.name}</div></li>`);//데이터 베이스에 오브젝트 정보칸 추가


    for(var i=0;i<2;i++){
     	  rune_obj=new scr_get_info_rune(runeid,rune.selections[i].perk);//검사할 메인 룬 타입, 검사할 섹션, 그거 위치
     	  scr_create_object(rune_obj,target);
      }
	
	rune=player_list[playid].perks.styles[1];//가지고있는룬정보 
	runeid=rune.style;//가지고있는 서브룬타입
	rune_obj=new scr_get_info_rune(runeid);//서브룬정보 받아오기
	
	
	target.append(`<li class=seli><div class="left_side"><img src="http://ddragon.leagueoflegends.com/cdn/img/\${rune_obj.img}" />\${rune_obj.name}</div></li>`);//데이터 베이스에 오브젝트 정보칸 추가
	rune=player_list[playid].perks.statPerks.offense;
	scr_create_ball(rune,target);
	

	rune=player_list[playid].perks.statPerks.flex;
	scr_create_ball(rune,target);

	rune=player_list[playid].perks.statPerks.defense;
	scr_create_ball(rune,target);
	
	if (map=="ARAM"){
		console.log("킬맵 미지원");
	}
	else{
		console.log("킬맵 지원");
	}
	
	scr_get_killmap(game_list[playid],playid);
	
	//victimId 처치당한놈
	//30520=30초 밀리초 계산임

         });//전적상세보기   
         
 $(document).on(`click`,`.seli`,function(){
       
	 	$(this).find(`.he`).toggleClass(`hidden`);
	 	$(this).find(`a`).toggleClass(`hidden`);
      });//룬상세보기
      
      
      
function scr_create_object(obj,target){
	target.append(`<li class=seli><div class="left_side"><img src="http://ddragon.leagueoflegends.com/cdn/img/\${obj.img}" />\${obj.name} : &nbsp<a>\${obj.stext}</a></div>
			<div class="he hidden">
			\${obj.ltext}
			</div>
			</li>`);//데이터 베이스에 오브젝트 정보칸 추가
}
      
 
function scr_create_ball(id,target){
	
	let img1=`https://opgg-static.akamaized.net/meta/images/lol/perkShard/\${id}.png`;//적응형능력치
	target.append(`<li class=seli><div class="left_side"><img src=\${img1} class="vkvus" />능력치</div>
			</li>`);//데이터 베이스에 오브젝트 정보칸 추가
}
            
      
function scr_change_list(index)
{
	$(`.se_list`).children().css(`display`,`none`);
    switch(index){
        case "데이터베이스":
        	$(`.DB`).css(`display`,`block`);
    break;
        case "직원관리":
        	$(`.Hu`).css(`display`,`block`);
    break;
    
        case "물품관리":
        	$(`.item`).css(`display`,`block`);
    break;    
    
    }

}


	function scr_rjator() {

		let name=$("input[name=name]").val();
		
		if (name!=""){
			global_name="";
		  scr_get_id(name);
		}

		
		}

		function scr_get_id(name){
			var index=null;
			var aa="dd";
			var URL="https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/"+`\${name}`+"?api_key="+key;
			$.ajax({
				url:URL,
				type:"get",
				success: function(data,status,xhr){
					index =data;
					console.log(URL);
					global_name=name;
					scr_get_info(index.id);
					global_puid=index.puuid;
					scr_get_match_list(global_puid);
			      //scr_get_timeline();
				},
				error :function(){
					console.log(error);
					console.log(status);
					console.log(xhr);
				}
				
			});
		  
		}
//Jett0
		function scr_get_info(id){
			let index=null;	 
		            $.ajax({
						url:"https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/"+id+"?api_key="+key,
						type:"get",
						success: function(data,status,xhr){
							index =data;
				            console.log(index);
				            console.log(index[0].tier);
						},
						error :function(){
							console.log(error);
							console.log(status);
							console.log(xhr);
						}
						
					});
		            
		            
		}

	function scr_get_timeline(id) {
		$("button[name=b2]").addClass("hidden");
		let index=null;	 
        $.ajax({
			url:"https://asia.api.riotgames.com/lol/match/v5/matches/"+id+"?api_key="+key,
			type:"get",
			 async: false,
			success: function(data,status,xhr){
				index =data;
				console.log(index);
				game_info_list[game_info_list.length]=index;
				for(var i=0;i<index.info.participants.length;i++){
					var _name=index.info.participants[i].summonerName;
					var _id=null;
					var _map=index.gameMode;
					if (global_name==_name){
						_id=index.info.participants[i];//처치 서바이버 다운 서바이버 처치 민간인  킬 어시 
						game_list[game_list.length]=id;
						player_list[player_list.length]=_id;
						
			        $(".game_main_in").append(`<div class="next_n wjswjr">
			        <input type="hidden" value=\${player_list.length-1} name="num">
			        <img class="img_class" src="http://ddragon.leagueoflegends.com/cdn/12.20.1/img/champion/\${_id.championName}.png" alt="사용레이더">
			        <input type="hidden" value=\${id} name="gameid"><input type="hidden" value=\${_map} name="gamemap">
			        \${_id.summonerName}처치수: \${_id.kills}어시스트: \${_id.assists}사망: \${_id.deaths}처치 민간인: \${_id.totalMinionsKilled}처치 정글몹: \${_id.neutralMinionsKilled} \${(_id.win)? "승리":"패배"} </div>`); 
					
					
					}
			
				}
				
				$("button[name=b2]").removeClass("hidden");
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		});      
		            
		
	}
	
	function scr_Addrjator() {
		
		let index=null;	 
        $.ajax({
			url:"https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+global_puid+"/ids?start="+game_list.length+"&count=10&api_key="+key,
			type:"get",
			success: function(data,status,xhr){
				index =data;
	
				for(var i=0;i<index.length;i++){
					scr_get_timeline(index[i]);
					
				}
				
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		}); 
		
	}
	
	function scr_get_match_list(id){
		
		let index=null;	 
        $.ajax({
			url:"https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"+id+"/ids?start=0&count=10&api_key="+key,
			type:"get",
			success: function(data,status,xhr){
				index =data;
				console.log(index);	
				$(".game_main_in").empty();	
				game_info_list=[];
				for(var i=0;i<index.length;i++){
					scr_get_timeline(index[i]);
					
				}
				
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		});     
	}
 
	function scr_get_enemy_list(id){
		
		let index=null;	 
        $.ajax({
			url:"https://ddragon.leagueoflegends.com/cdn/12.20.1/data/ko_KR/champion.json",
			type:"get",
			success: function(data,status,xhr){
				index =data;
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		});     
	}

	function scr_get_runes(version) {
		version='12.21.1';
		$.ajax({
			url:"https://ddragon.leagueoflegends.com/cdn/"+version+"/data/ko_KR/runesReforged.json",
			type:"get",
			success: function(data,status,xhr){
				console.log("시작");
				console.log(data);
				console.log("끝");
				global_perks=data;
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		});
		
		
	}
	
	function scr_get_killmap(id,num) {
		let num2=num;
		let index=null;	 
        $.ajax({
			url:"https://asia.api.riotgames.com/lol/match/v5/matches/"+id+"/timeline?api_key="+key,
			type:"get",
			 async: false,
			success: function(data,status,xhr){
				index =data;
				console.log(index);
				var qb=index.info.frames;
				var _inid;
				var map_w=15044;
				var map_h=15706;
				var _x,_y;
				var teem=game_info_list[num].info.participants;
				
				
				$(".team").eq(0).empty();	
				$(".team").eq(1).empty();	
				for(var qqw=0;qqw<teem.length;qqw++){
					$(".team").eq(1).append(`<div>하하</div>`);
				}
				
				
				$(".map ul").empty();	
				for(var i=1;i<qb.length;i++){
				
					for(var z=0;z<qb[i].events.length;z++){
						_inid=qb[i].events[z];
						if (_inid.type == "CHAMPION_KILL"){		
							_x=((_inid.position.x/map_w)*100).toFixed(3);
							_y=((_inid.position.y/map_h)*100).toFixed(3);
				        $(".map ul").append(`<li class="daas" style="left:\${_x}%;bottom:\${_y}%"></li>`); 
						
							
						}
						
					}
				}
				
			
			},
			error :function(){
				console.log(error);
				console.log(status);
				console.log(xhr);
			}
			
		});
		
	}
	
	function Rune_index(){

        this.name ="기본값";//var 이라서 접근 불가능
        this.ltext ="기본값";//var 이라서 접근 불가능
        this.stext ="기본값";//var 이라서 접근 불가능
        
		this.img=null;
        this.scr=function(){
            console.log(this.name,this.text)
        }
        }
        
	function scr_get_info_rune(main_rune,index=-1,subindex=-1) {
		var target_main_rune;
		var _info=new Rune_index();
		for(var i=0;i<global_perks.length;i++){
			if (global_perks[i].id==main_rune){
				target_main_rune=i;
				_info.name=global_perks[i].name;
				_info.img=global_perks[i].icon;
				break;
				}
		}
		
		if (index!=-1){
			
			if (subindex==-1){
				for(var i=1;i<=3;i++){

					for(var z=0;z<global_perks[target_main_rune].slots[i].runes.length;z++){
						
						if (global_perks[target_main_rune].slots[i].runes[z].id==index){
							subindex=i;
							if (subindex!=-1){break;}
						}
						if (subindex!=-1){break;}
					}
					
					if (subindex!=-1){break;}
				}
			}
			
			var _tar2=global_perks[target_main_rune].slots[subindex].runes;
			for(var i=0;i<_tar2.length;i++){	
				var _id2=_tar2[i];
				if (_id2.id==index){
					_info.name=_id2.name;
					_info.img=_id2.icon;
					_info.ltext=(_id2.longDesc).replace('<br><br>',"");
					var s_text=_id2.shortDesc;
					_info.stext=s_text.replace(/<[^>]*>?/g, '');					
					break;
				}
				
			}	
		}	
		
		return _info;
		
	}


 

    
	
</script>


</head>
<body>
	<section class="top next_n">
		<article class="game_main">
			<input class="rjatorckd" type="text" value="Jett0" name="name">
			<button type="button" onclick="scr_rjator()" name="b1">검색</button>
			<button type="button" onclick="scr_Addrjator()" name="b2"
				class="hidden">더보기</button>
			<section class="game_main_in">
				<!--그뭐냐 검색되고 전적 나오는곳 -->

			</section>
		</article>
		<article class="game_main_right_menu">
			<ul class="main_list next_n">
				<li onclick="scr_change_list(`데이터베이스`)">특성보기</li>
				<li onclick="scr_change_list(`직원관리`)">킬맵</li>
				<li onclick="scr_change_list(`물품관리`)">통계</li>
				<li onclick="scr_add_instance(`관광객`,'객체')">팀/적</li>
			</ul>
			<section class="se_list">
				<div class="DB">
					<ul>

					</ul>
				</div>
				<div class="Hu" style="display: none;">
					<div class="vks">
						<div class="team"></div>
						<div class="map"><ul></ul></div>
						<div class="team"></div>
					</div>
				
					<div class="timeline"></div>
				</div>
				<div class="item" style="display: none;">
					<ul>
					</ul>
				</div>
			</section>

		</article>
	</section>

</body>
</html>