#loader mixin

#mixin Mixin
#{targets: "teamroots.embers.power.DefaultEmberCapability"}
zenClass MixinEmberPipeConnectable{

    #mixin Overwrite
    function acceptsVolatile()as bool{
        return true as bool;
    }
}