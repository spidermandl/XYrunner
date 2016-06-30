-- RegisterMsg 注册信息返回
RegisterMsg = class(BaseMsg)

function RegisterMsg:Excute(response)
	if response == nil then
        print("用户名以被注册")
        return
	end

    self.callback:RegisterBtnFromSer(response)
end