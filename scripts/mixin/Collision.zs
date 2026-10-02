#loader mixin
import native.net.minecraft.world.World;

#mixin Mixin
#{targets: "youyihj.collision.block.absorber.Absorber"}
zenClass MixinAbsorberTransform{

    #mixin Overwrite
    function work(world as World)as bool{
        return false as bool;
    }
}