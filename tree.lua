local tree = {}

tree.distance = 20
tree.distance2 = tree.distance^2
tree.scale = 3
tree.img = {}
tree.img[1] = love.graphics.newImage("tree 1.png")
tree.img[2] = love.graphics.newImage("tree 2.png")
tree.img[3] = love.graphics.newImage("tree 3.png")
tree.img[4] = love.graphics.newImage("tree 4.png")
tree.img[5] = love.graphics.newImage("tree 5.png")
tree.img[6] = love.graphics.newImage("tree 6.png")
tree.img[7] = love.graphics.newImage("tree 7.png")
tree.img[8] = love.graphics.newImage("tree 8.png")
tree.img[9] = love.graphics.newImage("tree 9.png")
tree.img[10] = love.graphics.newImage("tree 10.png")

function tree.placeTree(tree, x, y)
  tree[#tree+1] = {x=x, y=y, img=love.math.random(#tree.img)}
end

tree:placeTree(	-43	,	-97	)
tree:placeTree(	-126	,	-48	)
tree:placeTree(	-62	,	-15	)
tree:placeTree(	-97	,	8	)
tree:placeTree(	-149	,	40	)
tree:placeTree(	-131	,	91	)
tree:placeTree(	-59	,	38	)
tree:placeTree(	-72	,	127	)
tree:placeTree(	-60	,	153	)
tree:placeTree(	2	,	152	)
tree:placeTree(	14	,	119	)
tree:placeTree(	56	,	80	)
tree:placeTree(	67	,	-82	)
tree:placeTree(	140	,	0	)
tree:placeTree(	141	,	117	)
tree:placeTree(	97	,	142	)
tree:placeTree(	223	,	-81	)
tree:placeTree(	215	,	132	)
tree:placeTree(	272	,	104	)
tree:placeTree(	282	,	-82	)
tree:placeTree(	307	,	136	)
tree:placeTree(	322	,	-115	)
tree:placeTree(	397	,	-139	)
tree:placeTree(	444	,	-103	)
tree:placeTree(	349	,	156	)
tree:placeTree(	407	,	107	)
tree:placeTree(	402	,	141	)
tree:placeTree(	531	,	-94	)
tree:placeTree(	490	,	134	)
tree:placeTree(	537	,	96	)
tree:placeTree(	576	,	120	)
tree:placeTree(	562	,	-38	)
tree:placeTree(	597	,	36	)
tree:placeTree(	642	,	71	)
tree:placeTree(	666	,	-3	)
tree:placeTree(	631	,	-101	)
tree:placeTree(	686	,	-65	)
tree:placeTree(	713	,	-165	)
tree:placeTree(	805	,	-232	)
tree:placeTree(	860	,	-186	)
tree:placeTree(	1003	,	-45	)
tree:placeTree(	1032	,	-121	)
tree:placeTree(	1073	,	-85	)
tree:placeTree(	1096	,	-126	)
tree:placeTree(	971	,	-229	)
tree:placeTree(	1132	,	-162	)
tree:placeTree(	1002	,	-271	)
tree:placeTree(	1194	,	-189	)
tree:placeTree(	1245	,	-253	)
tree:placeTree(	995	,	-341	)
tree:placeTree(	1056	,	-412	)
tree:placeTree(	1262	,	-399	)
tree:placeTree(	1046	,	-481	)
tree:placeTree(	1078	,	-543	)
tree:placeTree(	1329	,	-474	)
tree:placeTree(	1374	,	-538	)
tree:placeTree(	1163	,	-627	)
tree:placeTree(	1361	,	-621	)
tree:placeTree(	1154	,	-689	)
tree:placeTree(	1398	,	-681	)
tree:placeTree(	1171	,	-771	)
tree:placeTree(	1399	,	-757	)
tree:placeTree(	1292	,	-815	)
tree:placeTree(	1180	,	-835	)
tree:placeTree(	1077	,	-841	)
tree:placeTree(	1015	,	-811	)
tree:placeTree(	979	,	-890	)
tree:placeTree(	887	,	-893	)
tree:placeTree(	911	,	-950	)
tree:placeTree(	978	,	-981	)
tree:placeTree(	973	,	-1035	)
tree:placeTree(	1400	,	-838	)
tree:placeTree(	1495	,	-860	)
tree:placeTree(	1452	,	-913	)
tree:placeTree(	1198	,	-914	)
tree:placeTree(	1095	,	-932	)
tree:placeTree(	1048	,	-1015	)
tree:placeTree(	1144	,	-976	)
tree:placeTree(	1063	,	-1074	)
tree:placeTree(	1322	,	-970	)
tree:placeTree(	1194	,	-1015	)
tree:placeTree(	1418	,	-994	)
tree:placeTree(	1488	,	-1037	)
tree:placeTree(	1277	,	-1053	)
tree:placeTree(	1113	,	-1074	)
tree:placeTree(	1154	,	-1106	)
tree:placeTree(	1249	,	-1099	)





local abs = math.abs

function tree.inTree(tree, x, y)
  --local minTree = {}
  for it, t in ipairs(tree) do
    local dx2 = (t.x - x)^2
    if abs(dx2) < tree.distance2 then 
      local dy2 = (t.y - y)^2
      if abs(dy2) < tree.distance2 then 
        if dx2 + dy2 < tree.distance2 then
          return true
        end
      end
    end
  end
  return false
end

return tree