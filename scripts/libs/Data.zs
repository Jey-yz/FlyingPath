#reloadable
#priority 100000002

import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.util.Position3f;

function get(data as IData, path as string, spliter as string = "\\.")as IData{
    var keys as string[] = path.split(spliter);
    if(isNull(data)||isNull(data.asMap()))return data;
    var d as IData = data;
    for k in keys{
        if(isNull(k)||k=="")continue;
        if(!isNull(d.asMap())){
            if(d.asMap().keys has k){
                d = d.memberGet(k);
            }else{
                return null;
            }
        }
    }
    return d;
}

$ expand IData $ dataGet(path as string, spliter as string = "\\.")as IData{
    return get(this,path, spliter);
}

function set(data1 as IData, data2 as IData, path as string, spliter as string = "\\.")as IData{
    var keys as string[] = path.split(spliter);
    var d = IData.createEmptyMutableDataMap();
    if(isNull(data1)||data1.asMap().keys.length==0){
        return {keys[0]:data2}as IData;
    }
    if(keys.length==0)return data2;
    if(keys.length==1){
        if(keys[0]=="" || keys[0]==" ")return data2;
        d.memberSet(keys[0],data2);
        for i,j in data1.asMap(){
            d.memberSet(i,(i==keys[0])?data2:j);
        }
        return d as IData;
    }else{
        val newSpliter = (spliter=="\\.")?".":spliter;
        if(!isNull(get(data1, slicePath(keys, -1+keys.length, newSpliter), spliter))){
            d.memberSet(keys[-1+keys.length],data2);
            for i,j in get(data1, slicePath(keys, -1+keys.length, newSpliter), spliter).asMap(){
                d.memberSet(i, (i==keys[-1+keys.length])?data2:j);
            }
            return set(data1,d,slicePath(keys, -1+keys.length, newSpliter), spliter);
        }
        return set(data1, set({}, data2, keys[-1+keys.length], spliter), slicePath(keys, -1+keys.length, newSpliter), spliter);
    }
    return d;
}

$ expand IData $ dataSet(data as IData, path as string, spliter as string = "\\.")as IData{
    return set(this, data, path, spliter);
}

function slicePath(path as string[], depth as int, spliter as string = ".")as string{
    var out = "";
    var count = 0;
    for i in path{
        if(count<depth){
            if(count!=0)out+=spliter;
            out+=i;
            count+=1;
        }
    }
    return out;
}

function matches(data as IData, data2 as IData)as bool{
    return data==({}as IData + data).deepUpdate(data2,mods.zenutils.DataUpdateOperation.MERGE);
}
$ expand IData $ matches(data as IData)as bool{
    return matches(this,data);
}

// val test as IData = {A:{a:{1:123,2:{N:123,M:124}},b:455},B:789,D:{x:[123,345]}};
// print(set(test,111 as IData,"A/a/3/M/Y","/"));
// print(set(test,114514 as IData,"A.a.2.M"));
// print(set(test, 11 as IData, "C.a"));
// print(test.dataGet("A.a.2"));
// print(test.dataGet("A/c","/")??"null");
// print(test.dataSet([114,514]as IData,"D.y"));

function fromBlockPos(pos as IBlockPos, prefix as string = "", suffix as string = "")as IData{
    return {prefix~"x"~suffix:pos.x, prefix~"y"~suffix:pos.y, prefix~"z"~suffix:pos.z} as IData;
}

function toBlockPos(pos as IData, prefix as string = "", suffix as string = "")as IBlockPos{
    return IBlockPos.create(pos.dataGet(prefix~"x"~suffix)??0,pos.dataGet(prefix~"y"~suffix)??0,pos.dataGet(prefix~"z"~suffix)??0);
}

function fromPos3f(pos as Position3f, prefix as string = "", suffix as string = "")as IData{
    return {prefix~"x"~suffix:pos.x, prefix~"y"~suffix:pos.y, prefix~"z"~suffix:pos.z} as IData;
}

function toPos3f(pos as IData, prefix as string = "", suffix as string = "")as Position3f{
    return Position3f.create(pos.dataGet(prefix~"x"~suffix)??0,pos.dataGet(prefix~"y"~suffix)??0,pos.dataGet(prefix~"z"~suffix)??0);
}