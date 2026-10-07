-- Hotkeys capture the frontmost window; no clipboard copying is needed to read.
local M = {}
local base = 'http://127.0.0.1:8790'
local overlay, usercontent
local tokenPath = os.getenv('HOME') .. '/.hammerspoon/plainspeak-token'
local function token()
  local f = io.open(tokenPath, 'r'); if not f then return nil end
  local t = f:read('*a'):match('^%s*(.-)%s*$'); f:close(); return t
end
local function selectedText(app)
  local ok, value = pcall(function()
    local ax = hs.axuielement.applicationElement(app)
    local focused = ax:attributeValue('AXFocusedUIElement')
    return focused and focused:attributeValue('AXSelectedText')
  end)
  return ok and type(value) == 'string' and value or nil
end
local function close() if overlay then overlay:delete(); overlay = nil end end
local function show(id, secret)
  close()
  usercontent = hs.webview.usercontent.new('plainspeak')
  usercontent:setCallback(function(message)
    local body = message.body
    if type(body) ~= 'table' then return end
    if body.action == 'close' then close()
    elseif body.action == 'copy' and type(body.text) == 'string' then hs.pasteboard.setContents(body.text) end
  end)
  local screen = hs.screen.mainScreen():frame()
  overlay = hs.webview.new({x=screen.x+screen.w-570,y=screen.y+70,w=530,h=650}, {developerExtrasEnabled=false}, usercontent)
  overlay:windowStyle({'titled','closable','resizable','utility'}):windowTitle('Plainspeak'):closeOnEscape(true)
  overlay:level(hs.drawing.windowLevels.floating):allowTextEntry(true)
  overlay:url(base .. '/overlay#id=' .. id .. '&token=' .. secret):show()
end
local function capture(mode, context)
  -- Capture before opening the overlay so the panel itself never becomes input.
  local window = hs.window.focusedWindow()
  if not window then hs.alert.show('No focused window'); return end
  local app = window:application()
  if app:name() == 'Hammerspoon' then hs.alert.show('Focus the message window first'); return end
  local secret = token()
  if not secret then hs.alert.show('Start Plainspeak first'); return end
  local text = selectedText(app)
  if mode == 'draft' and (not text or text:match('^%s*$')) then
    hs.alert.show('Select your own draft text first. This app may not expose selection to macOS.'); return
  end
  local payload = {app=app:name(),title=window:title() or '',mode=mode,text=text,context=context or false}
  -- Drafts use selection only; reading captures the window with native Screen Recording permission.
  if mode == 'read' then
    local image = hs.window.snapshot(window:id())
    if not image then hs.alert.show('Capture failed. Enable Screen Recording for Hammerspoon.'); return end
    local uri = image:encodeAsURLString(false)
    payload.image_base64 = uri and uri:match('base64,(.+)')
    if not payload.image_base64 then hs.alert.show('Could not encode screenshot'); return end
  end
  hs.http.asyncPost(base .. '/capture', hs.json.encode(payload), {['Content-Type']='application/json',['Authorization']='Bearer '..secret}, function(code, body)
    local ok, data = pcall(hs.json.decode, body)
    if code ~= 202 or not ok then hs.alert.show(ok and data.error or 'Plainspeak unavailable. Check the session.'); return end
    show(data.request_id, secret)
  end)
end
M.read = function() capture('read',false) end
M.draft = function() capture('draft',false) end
M.context = function() capture('read',true) end
M.close = close
hs.hotkey.bind({'ctrl','alt','cmd'},'R',M.read)
hs.hotkey.bind({'ctrl','alt','cmd'},'D',M.draft)
hs.hotkey.bind({'ctrl','alt','cmd'},'G',M.context)
return M
