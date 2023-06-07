local PLUGIN = PLUGIN
PLUGIN.name = "Hint System"
PLUGIN.description = "Adds hints which might help you every now and then."
PLUGIN.author = "Riggs Mackay"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
ix.hints = ix.hints or {}
ix.hints.stored = ix.hints.stored or {}

function ix.hints.Register(message)
    table.insert(ix.hints.stored, message)
end

ix.hints.Register("Don't drink the water. They put something in it to make you forget.")
ix.hints.Register("Are you bored? Try making friends with someone or creating a story for your character!")
ix.hints.Register("The staff are here to help you. Show respect and cooperate with them.")
ix.hints.Register("Running, jumping, and other uncivil actions can result in re-education or even an arrest if repeated enough.")
ix.hints.Register("The Combine don't like it when you talk, so keep it to a minimum.")
ix.hints.Register("Life is bleak in the city without companions. Go find and make some friends!")
ix.hints.Register("Remember: This is a roleplay server. Voice Chat is IC only so play as your character and not as yourself.")
ix.hints.Register("The city is under constant surveillance so be careful with what you do.")
ix.hints.Register("Don't mess with the Combine, they took over Earth in only 7 hours.")
ix.hints.Register("Cause too much trouble and you may find yourself without a ration or even an entire block without rations.")
ix.hints.Register("Your designated inspection position is your apartment. Don't forget!")
ix.hints.Register("If you're looking for a way to get to a certain location, it's not a bad idea to ask for guidance.")
ix.hints.Register("Report crimes to officers or you might get in trouble for it.")
ix.hints.Register(".// before your message to talk out of character locally. Or try // to talk out of character globally")
ix.hints.Register("Obey the Combine's orders, or you might get in someplace you don't want to be in.")
ix.hints.Register("Civil Protection is protecting a civilized society, not the citizens OR you.")
ix.hints.Register("Don't enrage a local officer, or you'll find yourself being re-educated.")

if ( CLIENT ) then
    surface.CreateFont("HintFont", {
        font = "Consolas",
        size = 20,
        weight = 500,
        blursize = 0.5,
        shadow = true,
    })
    
    local nextHint = 0
    local hintEndRender = 0
    local bInHint = false
    local hint = nil
    local hintShow = false
    local hintAlpha = 0
    function PLUGIN:HUDPaint()
     if not LocalPlayer():IsCombine() then
        if ( nextHint < CurTime() ) then
            hint = ix.hints.stored[math.random(#ix.hints.stored)]
            nextHint = CurTime() + math.random(60,360)
            hintShow = true
            hintEndRender = CurTime() + 15
        end
    
        if not ( hint ) then return end
    
        if ( hintEndRender < CurTime() ) then
            hintShow = false
        end
    
        if ( hintShow == true ) then
            hintAlpha = Lerp(0.08, hintAlpha, 255)
        else
            hintAlpha = Lerp(0.05, hintAlpha, 0)
        end
        
        draw.DrawText(hint, "HintFont", ScrW() / 2, 1050, ColorAlpha(color_white, hintAlpha), TEXT_ALIGN_CENTER)
    end
end
end