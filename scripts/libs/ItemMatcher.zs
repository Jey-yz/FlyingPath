#reloadable 
#priority 10000001
import crafttweaker.item.IItemStack;
import crafttweaker.data.IData;
import crafttweaker.oredict.IOreDictEntry;
import native.java.lang.Object;

zenClass ItemMatcher{
    var checker as function(IItemStack)bool;

    zenConstructor(check as function(IItemStack)bool){
        this.checker = check;
    }

    zenConstructor(it as IItemStack){
        this.checker = function(item as IItemStack)as bool{
            if(isNull(item))return false;
            if(item.matches(it)||it.matches(item))return true;
            return false;
        }as function(IItemStack)bool;
    }

    zenConstructor(objs as Object[]){
        this.checker = function(item as IItemStack)as bool{
            if(isNull(item))return false;
            for i in objs{
                if(i instanceof IItemStack){
                    if(ItemMatcher(i as IItemStack).matcher()(item))return true;
                }else if(i instanceof IOreDictEntry){
                    if(ItemMatcher(i as IOreDictEntry).matcher()(item))return true;
                }else{
                    if(ItemMatcher(i as string).matcher()(item))return true;
                }
            }
            return false;
        };
    }

    zenConstructor(oredict as IOreDictEntry){
        this.checker = function(item as IItemStack)as bool{
            if(isNull(item))return false;
            if(oredict has item)return true;
            return false;
        }as function(IItemStack)bool;
    }

    zenConstructor(id as string){
        var meta = -1;
        val ids = id.split(":");
        if(ids.length==3)meta=ids[2] as int;
        this.checker = ItemMatcher(ids[0]~":"~ids[1],meta,{}as IData).matcher();
    }

    zenConstructor(id as string, meta as int){
        this.checker = ItemMatcher(id,meta,{}as IData).matcher();
    }

    zenConstructor(id as string, meta as int, tag as IData){
        this.checker = function(item as IItemStack)as bool{
            if(isNull(item)||isNull(item.definition))return false;
            if(item.definition.id==id && (item.metadata == meta || meta==-1)){
                if(tag=={}){return true;}
                else if(tag!={} && !item.hasTag){return false;}
                else{return tag.matches(item.tag);}
            }
            return false;
        }as function(IItemStack)bool;
    }

    function matcher() as function(IItemStack)bool{
        return this.checker;
    }

    function check(item as IItemStack) as bool{
        return this.checker(item);
    }

}

static allItems as function(IItemStack)bool = function(item as IItemStack)as bool{return true;};

function or(a as ItemMatcher, b as ItemMatcher)as ItemMatcher{
    return ItemMatcher(function(item as IItemStack)as bool{
        return a.matcher()(item) || b.matcher()(item);
    });
}
