--[[
author:Desmond
登录返回信息
]]
LoginMsg =class(BaseMsg)

function LoginMsg:Excute(response)

    --AppConst.SocketPort = 80

    if response == nil then
        print("用户名或密码不匹配")
        return
    end
    -- 进行判断 入行登陆成功 则post 获取服务器信息
    if response.token ~= nil then
        self.callback:LogInBtnFromSer(response)
    end
end