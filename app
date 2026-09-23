<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>Drafty</title>
  <!-- Fuente redonda y estilizada -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&display=swap" rel="stylesheet">
  
  <style>
    :root {
      --bg-gray: #F0F2F5;
      --card-bg: rgba(255, 255, 255, 0.88);
      --pastel-blue-light: #EBF2FF;
      --pastel-blue: #A2C2FB;
      --pastel-blue-dark: #6C9CE8;
      --accent-shadow: rgba(162, 194, 251, 0.4);
      --text-main: #4A5568;
    }

    * {
      box-sizing: border-box;
      user-select: none;
      -webkit-user-select: none;
      touch-action: none;
    }

    body {
      margin: 0;
      padding: 0;
      width: 100vw;
      height: 100vh;
      overflow: hidden;
      background-color: var(--bg-gray);
      font-family: 'Fredoka', cursive, sans-serif;
      color: var(--text-main);
    }

    /* --- CONTENEDOR DEL LIENZO --- */
    #canvas-viewport {
      position: absolute;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: var(--bg-gray);
      background-image: radial-gradient(#DEE4EC 1.5px, transparent 1.5px);
      background-size: 22px 22px;
      overflow: hidden;
    }

    #canvas-wrapper {
      position: relative;
      background: white;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
      border-radius: 12px;
      touch-action: none;
      transform-origin: center center;
    }

    .drawing-layer {
      position: absolute;
      top: 0;
      left: 0;
      border-radius: 12px;
    }

    /* --- BARRA SUPERIOR ELEGANTE --- */
    .top-bar {
      position: absolute;
      top: 16px;
      left: 16px;
      right: 16px;
      height: 60px;
      background: var(--card-bg);
      backdrop-filter: blur(14px);
      border-radius: 30px;
      box-shadow: 0 10px 25px var(--accent-shadow);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 20px;
      z-index: 50;
      border: 2px solid white;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .brand-logo {
      width: 36px;
      height: 36px;
      filter: drop-shadow(0 4px 6px var(--accent-shadow));
      animation: pulseLogo 3s infinite ease-in-out;
    }

    @keyframes pulseLogo {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.06); }
    }

    .brand-title {
      font-size: 22px;
      font-weight: 700;
      color: var(--pastel-blue-dark);
      letter-spacing: 0.5px;
    }

    .top-actions {
      display: flex;
      gap: 8px;
    }

    .pill-btn {
      background: white;
      border: 1.5px solid var(--pastel-blue-light);
      border-radius: 20px;
      padding: 7px 14px;
      color: var(--text-main);
      font-family: inherit;
      font-weight: 600;
      font-size: 13px;
      display: flex;
      align-items: center;
      gap: 5px;
      cursor: pointer;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
      transition: all 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    .pill-btn:active {
      transform: scale(0.92);
      background: var(--pastel-blue-light);
    }

    /* --- DOCK FLOTANTE DE PINCELES Y HERRAMIENTAS --- */
    .bottom-dock {
      position: absolute;
      bottom: 20px;
      left: 50%;
      transform: translateX(-50%);
      background: var(--card-bg);
      backdrop-filter: blur(16px);
      padding: 8px 14px;
      border-radius: 40px;
      box-shadow: 0 14px 30px var(--accent-shadow);
      display: flex;
      gap: 6px;
      align-items: center;
      z-index: 50;
      border: 2px solid white;
    }

    .tool-btn {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      border: none;
      background: transparent;
      color: var(--text-main);
      font-size: 19px;
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;
      position: relative;
      transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    .tool-btn.active {
      background: var(--pastel-blue);
      color: white;
      transform: translateY(-4px) scale(1.1);
      box-shadow: 0 6px 15px var(--accent-shadow);
    }

    /* Controles de color y grosor */
    .tool-settings {
      position: absolute;
      bottom: 85px;
      left: 50%;
      transform: translateX(-50%);
      background: var(--card-bg);
      backdrop-filter: blur(12px);
      padding: 10px 18px;
      border-radius: 30px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.06);
      display: flex;
      gap: 12px;
      align-items: center;
      z-index: 45;
      border: 2px solid white;
    }

    .color-picker-bubble {
      -webkit-appearance: none;
      border: none;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      outline: none;
      background: transparent;
    }
    .color-picker-bubble::-webkit-color-swatch-wrapper { padding: 0; }
    .color-picker-bubble::-webkit-color-swatch {
      border: 2px solid white;
      border-radius: 50%;
      box-shadow: 0 3px 6px rgba(0,0,0,0.15);
    }

    .brush-slider {
      -webkit-appearance: none;
      height: 6px;
      border-radius: 5px;
      background: #E2E8F0;
      outline: none;
    }
    .brush-slider::-webkit-slider-thumb {
      -webkit-appearance: none;
      width: 18px;
      height: 18px;
      border-radius: 50%;
      background: var(--pastel-blue-dark);
      cursor: pointer;
      border: 2px solid white;
      box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    /* --- PESTAÑA FLOTANTE DE FOTO DE REFERENCIA --- */
    .reference-panel {
      position: absolute;
      top: 90px;
      left: 20px;
      width: 170px;
      height: 220px;
      background: white;
      border-radius: 20px;
      box-shadow: 0 12px 25px rgba(0,0,0,0.12);
      border: 3px solid var(--pastel-blue-light);
      display: flex;
      flex-direction: column;
      z-index: 60;
      overflow: hidden;
      cursor: grab;
      touch-action: none;
    }

    .reference-panel.hidden { display: none; }

    .reference-header {
      background: var(--pastel-blue-light);
      padding: 6px 12px;
      font-size: 12px;
      font-weight: 700;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: var(--pastel-blue-dark);
    }

    .reference-img-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #FAFAFA;
      position: relative;
    }

    .reference-img-container img {
      max-width: 100%;
      max-height: 100%;
      object-fit: contain;
    }

    /* --- GESTIÓN DE CAPAS --- */
    .layers-panel {
      position: absolute;
      right: 20px;
      top: 90px;
      width: 180px;
      background: var(--card-bg);
      backdrop-filter: blur(12px);
      border-radius: 24px;
      padding: 12px;
      box-shadow: 0 12px 25px rgba(0,0,0,0.08);
      z-index: 55;
      border: 2px solid white;
      display: none;
      flex-direction: column;
      gap: 8px;
    }

    .layers-panel.open { display: flex; }

    .layer-item {
      padding: 8px 12px;
      background: white;
      border-radius: 14px;
      font-size: 13px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      cursor: pointer;
      border: 2px solid transparent;
      box-shadow: 0 2px 6px rgba(0,0,0,0.03);
    }

    .layer-item.active {
      border-color: var(--pastel-blue-dark);
      background: var(--pastel-blue-light);
    }

    /* --- MODAL SKETCHBOOK (CARPETA TIPO LIBRO) --- */
    .book-modal {
      position: fixed;
      inset: 0;
      background: rgba(43, 52, 69, 0.45);
      backdrop-filter: blur(8px);
      z-index: 100;
      display: none;
      align-items: center;
      justify-content: center;
    }

    .book-modal.open { display: flex; }

    .book-container {
      width: 88vw;
      max-width: 480px;
      height: 72vh;
      background: #FDFEFE;
      border-radius: 26px;
      border: 10px solid #D6E4F0;
      box-shadow: 0 25px 50px rgba(0,0,0,0.2), inset 15px 0 25px rgba(0,0,0,0.05);
      position: relative;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .book-spine {
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 22px;
      background: linear-gradient(to right, #A2C2FB, #8FB5F7);
      border-right: 3px solid rgba(255,255,255,0.4);
    }

    .book-content {
      margin-left: 28px;
      padding: 20px;
      flex: 1;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
    }

    .pages-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 14px;
      margin-top: 15px;
    }

    .page-card {
      background: white;
      border-radius: 14px;
      padding: 6px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      border: 1px solid #E8EEF5;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .page-card img {
      width: 100%;
      height: 110px;
      object-fit: cover;
      border-radius: 10px;
    }

    /* Indicador de Presión Stylus */
    .pressure-pill {
      font-size: 11px;
      color: #94A3B8;
      background: white;
      padding: 2px 8px;
      border-radius: 10px;
    }
  </style>
</head>
<body>

  <!-- Lienzo y vista -->
  <div id="canvas-viewport">
    <div id="canvas-wrapper" style="width: 380px; height: 600px;">
      <!-- Las capas de dibujo se generan por script -->
    </div>
  </div>

  <!-- Barra Superior -->
  <header class="top-bar">
    <div class="brand">
      <!-- Logo paleta de colores pastel -->
      <svg class="brand-logo" viewBox="0 0 64 64" fill="none">
        <path d="M32 6C16.5 6 6 16.5 6 32c0 15 12 26 26 26 5 0 8-3 8-7 0-3-1-4.5-1-6.5 0-2.5 2-4.5 4.5-4.5H48c8 0 12-7 12-14 0-14-12.5-26-28-26z" fill="#BBD5FD"/>
        <circle cx="20" cy="24" r="4.5" fill="#FFB3BA"/>
        <circle cx="32" cy="18" r="4.5" fill="#BAFFC9"/>
        <circle cx="44" cy="24" r="4.5" fill="#FFFFBA"/>
        <circle cx="24" cy="38" r="4.5" fill="#FFDFBA"/>
      </svg>
      <span class="brand-title">Drafty</span>
    </div>

    <div class="top-actions">
      <button class="pill-btn" id="undoBtn" title="Atajo: Z">↩ <b>Z</b></button>
      <button class="pill-btn" id="redoBtn" title="Atajo: Y">↪ <b>Y</b></button>
      <button class="pill-btn" id="toggleRefBtn">🖼 Ref</button>
      <button class="pill-btn" id="layersBtn">📑 Capas</button>
      <button class="pill-btn" id="openBookBtn" style="background: var(--pastel-blue-light); color: var(--pastel-blue-dark);">📖 Libro</button>
    </div>
  </header>

  <!-- Pestaña flotante de foto de referencia -->
  <div class="reference-panel hidden" id="refPanel">
    <div class="reference-header" id="refDragHandle">
      <span>Referencia</span>
      <span style="cursor:pointer;" id="closeRefBtn">✕</span>
    </div>
    <div class="reference-img-container">
      <img id="refImg" src="" style="display:none;" />
      <label for="refInput" id="refPlaceholder" style="font-size: 11px; text-align: center; color: #94A3B8; cursor: pointer; padding: 10px;">
        Toca aquí para cargar foto del dispositivo
      </label>
      <input type="file" id="refInput" accept="image/*" style="display:none;" />
    </div>
  </div>

  <!-- Panel de Capas -->
  <div class="layers-panel" id="layersPanel">
    <div style="display:flex; justify-content:space-between; align-items:center; font-size:12px; font-weight:700;">
      <span>Capas</span>
      <button class="pill-btn" id="addLayerBtn" style="padding: 2px 8px;">+ Nueva</button>
    </div>
    <div id="layersList" style="display:flex; flex-direction:column; gap:6px;"></div>
  </div>

  <!-- Opciones de Color y Tamaño flotante -->
  <div class="tool-settings">
    <input type="color" id="colorPicker" class="color-picker-bubble" value="#3B4252">
    <input type="range" id="brushSize" class="brush-slider" min="1" max="50" value="8">
    <span class="pressure-pill" id="pressureVal">Stylus: 100%</span>
  </div>

  <!-- Dock inferior de pinceles -->
  <nav class="bottom-dock">
    <button class="tool-btn active" data-tool="pen" title="Pluma">✒️</button>
    <button class="tool-btn" data-tool="marker" title="Marcador Fino">🖊️</button>
    <button class="tool-btn" data-tool="crayon" title="Crayón">🖍️</button>
    <button class="tool-btn" data-tool="eraser" title="Borrador">🧹</button>
    <button class="tool-btn" data-tool="smudge" title="Mezclar">💧</button>
    <button class="tool-btn" data-tool="pan" title="Mover Lienzo">✋</button>
  </nav>

  <!-- Modal Libro / Carpeta de Dibujos -->
  <div class="book-modal" id="bookModal">
    <div class="book-container">
      <div class="book-spine"></div>
      <div class="book-content">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <div>
            <h2 style="margin:0; font-size:22px; color:var(--pastel-blue-dark);">Mi Cuaderno de Bocetos</h2>
            <small style="color:#A0AEC0;">Hojas guardadas en dispositivo</small>
          </div>
          <button class="pill-btn" id="closeBookModalBtn">Cerrar</button>
        </div>

        <div style="margin-top:16px; display:flex; gap:10px;">
          <button class="pill-btn" id="savePageBtn" style="background: var(--pastel-blue-dark); color:white; flex:1;">
            💾 Guardar Hoja Actual
          </button>
        </div>

        <div class="pages-grid" id="bookPagesGrid"></div>
      </div>
    </div>
  </div>

  <script>
    // --- ESTADO GENERAL ---
    const state = {
      tool: 'pen',
      color: '#3B4252',
      size: 8,
      layers: [],
      currentLayerIdx: 0,
      undoStack: [],
      redoStack: [],
      isDrawing: false,
      lastX: 0,
      lastY: 0,
      pan: { x: 0, y: 0 },
      isPanning: false,
      panStart: { x: 0, y: 0 }
    };

    const canvasWrapper = document.getElementById('canvas-wrapper');
    const pressureVal = document.getElementById('pressureVal');
    const width = 380;
    const height = 600;

    // --- SISTEMA DE CAPAS ---
    function addLayer() {
      const canvas = document.createElement('canvas');
      canvas.width = width;
      canvas.height = height;
      canvas.className = 'drawing-layer';
      const ctx = canvas.getContext('2d', { willReadFrequently: true });
      
      // Fondo blanco solo en la primera capa base
      if(state.layers.length === 0) {
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(0, 0, width, height);
      }

      const layerObj = { canvas, ctx, name: `Capa ${state.layers.length + 1}` };
      state.layers.push(layerObj);
      canvasWrapper.appendChild(canvas);
      setActiveLayer(state.layers.length - 1);
      renderLayersList();
      saveState();
    }

    function setActiveLayer(idx) {
      state.currentLayerIdx = idx;
      renderLayersList();
    }

    function renderLayersList() {
      const list = document.getElementById('layersList');
      list.innerHTML = '';
      state.layers.forEach((layer, idx) => {
        const item = document.createElement('div');
        item.className = `layer-item ${idx === state.currentLayerIdx ? 'active' : ''}`;
        item.innerHTML = `<span>${layer.name}</span> <small>${idx === 0 ? '(Fondo)' : ''}</small>`;
        item.onclick = () => setActiveLayer(idx);
        list.appendChild(item);
      });
    }

    // Inicializar 1 capa
    addLayer();

    function currentCtx() {
      return state.layers[state.currentLayerIdx].ctx;
    }

    // --- RECONOCIMIENTO DE PRESIÓN Y DIBUJO ---
    function getCanvasCoords(e) {
      const rect = canvasWrapper.getBoundingClientRect();
      return {
        x: (e.clientX - rect.left),
        y: (e.clientY - rect.top)
      };
    }

    canvasWrapper.addEventListener('pointerdown', (e) => {
      if (state.tool === 'pan') {
        state.isPanning = true;
        state.panStart = { x: e.clientX - state.pan.x, y: e.clientY - state.pan.y };
        return;
      }

      state.isDrawing = true;
      const coords = getCanvasCoords(e);
      state.lastX = coords.x;
      state.lastY = coords.y;

      drawStroke(e, true);
    });

    window.addEventListener('pointermove', (e) => {
      if (state.isPanning) {
        state.pan.x = e.clientX - state.panStart.x;
        state.pan.y = e.clientY - state.panStart.y;
        canvasWrapper.style.transform = `translate(${state.pan.x}px, ${state.pan.y}px)`;
        return;
      }
      if (!state.isDrawing) return;
      drawStroke(e, false);
    });

    window.addEventListener('pointerup', () => {
      if (state.isDrawing) {
        state.isDrawing = false;
        saveState();
      }
      state.isPanning = false;
    });

    function drawStroke(e, isStart) {
      const ctx = currentCtx();
      const coords = getCanvasCoords(e);
      
      // Presión del stylus (e.pressure va de 0.0 a 1.0; en ratón o toque normal suele ser 0.5 o 1)
      let pressure = e.pressure && e.pressure > 0 ? e.pressure : 0.8;
      pressureVal.innerText = `Stylus: ${Math.round(pressure * 100)}%`;

      let strokeWidth = state.size * (pressure * 1.5);
      if (strokeWidth < 1) strokeWidth = 1;

      ctx.save();

      if (state.tool === 'pen') {
        ctx.strokeStyle = state.color;
        ctx.fillStyle = state.color;
        ctx.lineWidth = strokeWidth;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';

        ctx.beginPath();
        ctx.moveTo(state.lastX, state.lastY);
        ctx.lineTo(coords.x, coords.y);
        ctx.stroke();

      } else if (state.tool === 'marker') {
        ctx.globalAlpha = 0.5;
        ctx.strokeStyle = state.color;
        ctx.lineWidth = strokeWidth * 0.9;
        ctx.lineCap = 'square';
        ctx.beginPath();
        ctx.moveTo(state.lastX, state.lastY);
        ctx.lineTo(coords.x, coords.y);
        ctx.stroke();

      } else if (state.tool === 'crayon') {
        // Efecto textura crayón con micropuntos
        ctx.fillStyle = state.color;
        const dist = Math.hypot(coords.x - state.lastX, coords.y - state.lastY) || 1;
        for (let i = 0; i < dist; i += 2) {
          const t = i / dist;
          const px = state.lastX + (coords.x - state.lastX) * t;
          const py = state.lastY + (coords.y - state.lastY) * t;
          
          for (let p = 0; p < 8; p++) {
            const angle = Math.random() * Math.PI * 2;
            const r = Math.random() * strokeWidth;
            ctx.globalAlpha = Math.random() * 0.45;
            ctx.fillRect(px + Math.cos(angle)*r, py + Math.sin(angle)*r, 1.6, 1.6);
          }
        }

      } else if (state.tool === 'eraser') {
        ctx.globalCompositeOperation = state.currentLayerIdx === 0 ? 'source-over' : 'destination-out';
        ctx.strokeStyle = state.currentLayerIdx === 0 ? '#FFFFFF' : 'rgba(0,0,0,1)';
        ctx.lineWidth = strokeWidth * 1.8;
        ctx.lineCap = 'round';
        ctx.beginPath();
        ctx.moveTo(state.lastX, state.lastY);
        ctx.lineTo(coords.x, coords.y);
        ctx.stroke();

      } else if (state.tool === 'smudge') {
        // Mezclado: toma muestra de píxeles adyacentes y difumina
        try {
          const sampleSize = Math.max(12, Math.floor(strokeWidth * 1.2));
          const imgData = ctx.getImageData(coords.x - sampleSize/2, coords.y - sampleSize/2, sampleSize, sampleSize);
          ctx.globalAlpha = 0.15;
          ctx.putImageData(imgData, coords.x - sampleSize/2 + (coords.x - state.lastX)*0.2, coords.y - sampleSize/2 + (coords.y - state.lastY)*0.2);
        } catch(e) {}
      }

      ctx.restore();
      state.lastX = coords.x;
      state.lastY = coords.y;
    }

    // --- HISTORIAL DESHACER (Z) / REHACER (Y) ---
    function saveState() {
      const activeCanvas = state.layers[state.currentLayerIdx].canvas;
      state.undoStack.push(activeCanvas.toDataURL());
      if (state.undoStack.length > 25) state.undoStack.shift();
      state.redoStack = []; // limpiar redo
    }

    function undo() {
      if (state.undoStack.length > 1) {
        state.redoStack.push(state.undoStack.pop());
        const prevImgSrc = state.undoStack[state.undoStack.length - 1];
        restoreState(prevImgSrc);
      }
    }

    function redo() {
      if (state.redoStack.length > 0) {
        const nextImgSrc = state.redoStack.pop();
        state.undoStack.push(nextImgSrc);
        restoreState(nextImgSrc);
      }
    }

    function restoreState(dataUrl) {
      const img = new Image();
      img.src = dataUrl;
      img.onload = () => {
        const ctx = currentCtx();
        ctx.clearRect(0, 0, width, height);
        ctx.drawImage(img, 0, 0);
      };
    }

    // Atajos de Teclado Z e Y
    window.addEventListener('keydown', (e) => {
      if (e.key.toLowerCase() === 'z') undo();
      if (e.key.toLowerCase() === 'y') redo();
    });
    document.getElementById('undoBtn').onclick = undo;
    document.getElementById('redoBtn').onclick = redo;

    // --- SELECTOR DE HERRAMIENTAS ---
    document.querySelectorAll('.tool-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.tool-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        state.tool = btn.dataset.tool;
      });
    });

    document.getElementById('colorPicker').oninput = (e) => state.color = e.target.value;
    document.getElementById('brushSize').oninput = (e) => state.size = e.target.value;

    // --- PESTAÑA FOTO DE REFERENCIA (IMPORTACIÓN Y ARRASTRE) ---
    const refPanel = document.getElementById('refPanel');
    const toggleRefBtn = document.getElementById('toggleRefBtn');
    const closeRefBtn = document.getElementById('closeRefBtn');
    const refInput = document.getElementById('refInput');
    const refImg = document.getElementById('refImg');
    const refPlaceholder = document.getElementById('refPlaceholder');
    const refDragHandle = document.getElementById('refDragHandle');

    toggleRefBtn.onclick = () => refPanel.classList.toggle('hidden');
    closeRefBtn.onclick = () => refPanel.classList.add('hidden');
    refPlaceholder.onclick = () => refInput.click();

    refInput.onchange = (e) => {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (evt) => {
          refImg.src = evt.target.result;
          refImg.style.display = 'block';
          refPlaceholder.style.display = 'none';
        };
        reader.readAsDataURL(file);
      }
    };

    // Arrastre simple de la foto de referencia
    let isDraggingRef = false, refOffset = { x: 0, y: 0 };
    refDragHandle.addEventListener('pointerdown', (e) => {
      isDraggingRef = true;
      refOffset.x = e.clientX - refPanel.offsetLeft;
      refOffset.y = e.clientY - refPanel.offsetTop;
    });
    window.addEventListener('pointermove', (e) => {
      if (!isDraggingRef) return;
      refPanel.style.left = (e.clientX - refOffset.x) + 'px';
      refPanel.style.top = (e.clientY - refOffset.y) + 'px';
    });
    window.addEventListener('pointerup', () => isDraggingRef = false);

    // Toggle panel capas
    document.getElementById('layersBtn').onclick = () => {
      document.getElementById('layersPanel').classList.toggle('open');
    };
    document.getElementById('addLayerBtn').onclick = addLayer;

    // --- MODAL DE CARPETA / LIBRO DE BOCETOS ---
    const bookModal = document.getElementById('bookModal');
    const bookPagesGrid = document.getElementById('bookPagesGrid');
    document.getElementById('openBookBtn').onclick = () => {
      renderBookPages();
      bookModal.classList.add('open');
    };
    document.getElementById('closeBookModalBtn').onclick = () => bookModal.classList.remove('open');

    function mergeLayersToCanvas() {
      const exportCanvas = document.createElement('canvas');
      exportCanvas.width = width;
      exportCanvas.height = height;
      const expCtx = exportCanvas.getContext('2d');
      state.layers.forEach(layer => expCtx.drawImage(layer.canvas, 0, 0));
      return exportCanvas;
    }

    document.getElementById('savePageBtn').onclick = () => {
      const merged = mergeLayersToCanvas();
      const dataUrl = merged.toDataURL('image/png');

      // 1. Guardar en la carpeta/libro visual (LocalStorage)
      let pages = JSON.parse(localStorage.getItem('drafty_book_pages') || '[]');
      pages.unshift({
        id: Date.now(),
        img: dataUrl,
        date: new Date().toLocaleDateString()
      });
      localStorage.setItem('drafty_book_pages', JSON.stringify(pages));

      // 2. Descargar automáticamente en la galería del dispositivo
      const link = document.createElement('a');
      link.download = `Drafty_Hoja_${Date.now()}.png`;
      link.href = dataUrl;
      link.click();

      renderBookPages();
      alert('¡Hoja guardada en tu libro y en tu dispositivo!');
    };

    function renderBookPages() {
      let pages = JSON.parse(localStorage.getItem('drafty_book_pages') || '[]');
      bookPagesGrid.innerHTML = '';
      if(pages.length === 0) {
        bookPagesGrid.innerHTML = '<p style="grid-column: span 2; text-align:center; color:#94A3B8;">Aún no tienes hojas en tu libro. ¡Dibuja algo!</p>';
        return;
      }
      pages.forEach(p => {
        const card = document.createElement('div');
        card.className = 'page-card';
        card.innerHTML = `
          <img src="${p.img}" />
          <span style="font-size:11px; margin-top:6px; color:#64748B;">${p.date}</span>
        `;
        bookPagesGrid.appendChild(card);


      });
    }
  </script>
</body>
</html>
