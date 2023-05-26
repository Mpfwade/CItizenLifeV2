local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
    self:SetSize(ScrW() / 4, 400)
    self:Center()
    self:SetTitle("")
    self:MakePopup()
    self:SetBackgroundBlur(true)

    local quizData = {
        {
            question = "Yes",
            options = {
                {
                    text = "I think so",
                    correct = true
                },
                {
                    text = "Maybe?",
                    correct = false
                },
                {
                    text = "Yes",
                    correct = true
                },
                {
                    text = "No",
                    correct = false
                }
            }
        },
        {
            question = "No",
            options = {
                {
                    text = "Yes",
                    correct = false
                },
                {
                    text = "No",
                    correct = true
                },
                {
                    text = "Maybe",
                    correct = false
                },
                {
                    text = "Shouldn't be",
                    correct = true
                }
            }
        }
    }

    local currentQuestion = 1
    local correctAnswers = 0

    local function LoadQuestion()
        local questionData = quizData[currentQuestion]
        self.questionLabel:SetText(questionData.question)

        if self.optionButtons then
            for _, button in ipairs(self.optionButtons) do
                button:Remove()
            end
        end

        self.optionButtons = {}
        local yOffset = 80

        for i, option in ipairs(questionData.options) do
            local optionButton = vgui.Create("DButton", self)
            optionButton:SetText(option.text)
            optionButton:SetPos(20, yOffset)
            optionButton:SetSize(360, 30)

            optionButton.DoClick = function()
                if option.correct then
                    correctAnswers = correctAnswers + 1
                    print("Correct answer!")
                    -- Add your desired actions for a correct answer here
                else
                    print("Wrong answer!")
                    -- Add your desired actions for a wrong answer here
                end

                currentQuestion = currentQuestion + 1

                if currentQuestion <= #quizData then
                    LoadQuestion()
                else
                    if correctAnswers == #quizData then
                        netstream.Start("SubmitCPPaper", true)
                    end

                    self:Close()
                end
            end

            yOffset = yOffset + 40
            table.insert(self.optionButtons, optionButton)
        end
    end

    self.questionLabel = vgui.Create("DLabel", self)
    self.questionLabel:SetPos(20, 40)
    self.questionLabel:SetSize(360, 20)
    LoadQuestion()
end

vgui.Register("ixJobQuiz", PANEL, "DFrame")