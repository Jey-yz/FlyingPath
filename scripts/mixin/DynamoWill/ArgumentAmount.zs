#loader mixin

#mixin Mixin
#{targets: ["cofh.thermalexpansion.block.machine.TileMachineBase","cofh.thermalexpansion.block.dynamo.TileDynamoBase"]}
zenClass MixinArgumentsAmount{
    #mixin Static
    #mixin ModifyConstant{method:"config",constant:{intValue:0, ordinal:6}}
    function alwaysValid(original as int)as int{
        return 1;
    }
}
