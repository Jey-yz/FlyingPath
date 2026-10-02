#reloadable
#priority 2000
import scripts.libs.Craft;
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.world.IBlockPos;

val mbJEI=JEI.createJei("MultiBlock",game.localize("jei.category.multi_block"));
mbJEI.setModid("crafttweaker");
mbJEI.setIcon(<embers:tinker_hammer>);
mbJEI.addRecipeCatalyst(<embers:tinker_hammer>);
mbJEI.setBackground(IJeiUtils.createBackground(0,0,200,154,"contenttweaker:textures/gui/MultiBlock_JEI.png"));
mbJEI.addSlot(IJeiUtils.createItemSlot("hammer",170,125,true,true));
for i in 0 to 7{
    for j in 0 to 7{
        mbJEI.addSlot(IJeiUtils.createItemSlot("input_"~j~"_"~i,12+j*19,11+i*19,true,true));
    }
}
for i in 0 to 4{
    mbJEI.addSlot(IJeiUtils.createItemSlot("output_"~i,170,11+i*27,false,true));
}
mbJEI.register();

//the input size must be a rectangle
function resize(ins as IIngredient[][])as IIngredient[][]{
    if(ins.length>=7)return ins;
    var out  as IIngredient[][] = [];
    val emptyLine as IIngredient[] = [<contenttweaker:gunmu>,<contenttweaker:gunmu>,<contenttweaker:gunmu>,<contenttweaker:gunmu>,<contenttweaker:gunmu>,<contenttweaker:gunmu>,<contenttweaker:gunmu>];
    if(ins.length<7){
        for i in 0 to (-ins.length+7)/2{
            out += emptyLine;
        }
    }
    for i in ins{
        var newLine as IIngredient[] = [];
        if(ins.length<7){
            for j in 0 to (-i.length+7)/2{
                newLine += <contenttweaker:gunmu>;
            }
        }
        for j in i{
            val newIngredient = j;
            newLine += newIngredient;
        }
        if(ins.length<7){
            for j in 0 to (-i.length+8)/2{
                newLine += <contenttweaker:gunmu>;
            }
        }
        out += newLine;
    }
    for i in 0 to (-ins.length+8)/2{
        out += emptyLine;
    }
    return out;
}

function addPosTips(ins as IIngredient[][], x as int, y as int, z as int)as IIngredient[][]{
    var out  as IIngredient[][] = [];
    for pz in 0 to 7{
        var newLine as IIngredient[] = [];
        for px in 0 to 7{
            var newIngredient = ins[pz][px].items[0];
            if(((-z+pz)==0 && y==0 && (-x+px)==0)){
                newIngredient=Craft.addLore(newIngredient,game.localize("jei.tooltip.multi_block.center"));
            }
            newIngredient = Craft.addLore(newIngredient,game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(-x+px,y,-z+pz).asString());
            newLine += newIngredient;
        }
        out += newLine;
    }
    return out;
}

function layers(ins as IIngredient[][][])as IIngredient[][]{
    var out as IIngredient[][] = [];
    for z in 0 to 7{
        var newLine as IIngredient[] = [];
        for x in 0 to 7{
            var ing as IIngredient = ins[0][z][x];
            for y in 0 to ins.length{
                if(y!=0)ing = ing.or(ins[y][z][x]);
            }
            newLine += ing;
        }
        out += newLine;
    }
    return out;
}

function addRecipe(ins as IIngredient[][], out as IItemStack[], input as IIngredient = <embers:tinker_hammer>)as void{
    val recipe = JEI.createJeiRecipe("MultiBlock");
    recipe.addInput(input);
    for i in ins{
        for j in i{
            recipe.addInput(j);
        }
    }
    for i in out{
        recipe.addOutput(i);
    }
    recipe.build();
}