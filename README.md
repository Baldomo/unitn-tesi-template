# Template di tesi per Università degli studi di Trento <!-- omit in toc -->

#### Indice <!-- omit in toc -->

- [Requisiti](#requisiti)
- [Struttura dei file](#struttura-dei-file)
- [Editing del testo](#editing-del-testo)
- [Creazione PDF](#creazione-pdf)
- [FAQ e problemi comuni](#faq-e-problemi-comuni)

---

Questa repository é un [template Github](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) per documenti di tesi di laurea triennale standard provvisti dall'Universitá degli Studi di Trento. Tutti i file appartenenti a questo progetto sono originariamente disponibili [sul sito InfoStudenti](https://infostudenti.unitn.it/it/conseguimento-titolo-lauree-disi#node-20345), ma sono stati modificati e modernizzati estensivamente.

Il numero massimo di facciate é 30. Sono inclusi nel conteggio:
- indice
- sommario
- capitoli

E sono esclusi:
- frontespizio
- ringraziamenti
- allegati

### Requisiti
Nessun software specifico é necessario per utilizzare questa repository su Linux o MacOS, mentre su Windows occorre installare [Git Bash](https://git-scm.com/download/win) (che dovrebbe essere già installato in ogni caso per clonare questa repository).

Si consiglia [Visual Studio Code](https://code.visualstudio.com/download) o [VSCodium](https://vscodium.com/#install) per lavorare sui file. Alcune impostazioni dell'editor e integrazioni sono incluse in questa repository.

### Struttura dei file
La struttura di questa repository può essere riassunta come segue:
```shell
📁 bin                      # Eseguibili necessari
📁 build                    # Output dei PDF
📂 src                      # Codice sorgente
  📂 chapters               # Capitoli
  📂 figures                # Grafiche e immagini
  📂 sections               # Macrosezioni del documento
  📘 index.tex              # Corpo principale del testo
  📘 config.tex             # Configurazione di librerie
  📘 _preamble.tex          # Definisce l'inizio del documento
  📘 _postamble.tex         # Definisce bibliografia e allegati
  📚 biblio.bib             # File di specifica della bibliografia
📄 make                     # Script di compilazione
⚙️ Tectonic.toml            # Backend service configuration file
```

Spiegazione approfondita:
- `bin`: gli eseguibili necessari al progetto vengono scaricati in questa cartella dallo script di compilazione (ad esempio [Tectonic](https://tectonic-typesetting.github.io/en-US/))
- `build`: i file PDF compilati e altri file temporanei (log del compilatore etc.) vengono generati in questa cartella
- `src`: contiene codice sorgente e in generale, file usati per creare il documento finale
  - `chapters`: contiene i vari capitoli e altri file di contenuti testuali del documento
  - `figures`: contiene file di contenuti grafici (immagini, grafiche vettoriali, etc.)
  - `sections`: contiene la struttura delle macrosezioni del documento, come definite nel template originale fornito dall'Università. Generalmente non necessita di modifiche
  - `index.tex`: contiene la definizione del corpo principale del testo. Ogni capitolo da inserire nel documento finale va incluso/importato in questo file
  - `config.tex`: contiene altre librerie definite dall'utente e la relativa configurazione. Viene automaticamente importato da `_preamble.tex` e compilato nel PDF finale
  - `_preamble.tex` (*non necessita di modifiche*): questo file importa le librerie LaTeX necessarie, aggiunge la pagina iniziale, i ringraziamenti (opzionali) e l'indice. Chiama `\begin{document}`
  - `_postamble.tex` (*non necessita di modifiche*): questo file aggiunge bibliografia e allegati. Chiama `\end{document}`
- `make`: script di compilazione e varie utility per gestire il progetto (ad esempio scaricare Tectonic, creare le cartelle ed eseguire comandi) creato con [makesh](https://github.com/Baldomo/makesh)
- `Tectonic.toml`: file di configurazione per Tectonic (vedi [documentazione ufficiale](https://tectonic-typesetting.github.io/book/latest/ref/tectonic-toml.html)). Generalmente non necessita di modifiche

### Editing del testo
Sono riportate di seguito alcune procedure comuni per aggiungere contenuti al documento.

<details>
  <summary>Aggiungere un nuovo capitolo</summary>

---

1. Creare un file LaTeX nella cartella `chapters` (ad esempio `capitolo4.tex`)
2. Importare il file in `index.tex` (ad esempio con `\input{chapters/capitolo4.tex}`)

---

</details>

<details>
  <summary>Inserire un'immagine, grafica o figura</summary>

---

> Per attivare TikZ, `pgfplots` o altre librerie basta definirle in `config.tex`

- Grafica LaTeX:
  - Vedi [`pgfplots`](https://www.overleaf.com/learn/latex/Pgfplots_package) per grafici tecnici e scientifici
  - Vedi [TikZ](https://www.overleaf.com/learn/latex/TikZ_package) per qualunque tipo di figure geometriche, di basso livello
- Grafica vettoriale o SVG: vedi articolo "[How to include an SVG image in LaTeX](http://mirrors.ctan.org/info/svg-inkscape/InkscapePDFLaTeX.pdf)"
- PDF (vedi anche documentazione della libreria `graphicx` in [inglese](http://mirrors.ctan.org/macros/latex/required/graphics/grfguide.pdf) o [italiano](http://mirrors.ctan.org/info/italian/itgrfguide/itgrfguide.pdf)):
  1. Inserire il file nella cartella `figures` (ad esempio `image.pdf`)
  2. Importare il file usando `graphicx`, che é già incluso e attivo nel progetto (ad esempio con `\includegraphics{figures/image.pdf}`)
- Immagine raster (PNG, JPEG, etc.): uguale a PDF usando `graphicx`

In generale per `graphicx` si consiglia di avvolgere `\includegraphics` in un blocco LaTeX per le figure, per controllarne il posizionamento rispetto al testo (vedi [documentazione](https://www.overleaf.com/learn/latex/Inserting_Images#Positioning) per altri esempi):
```latex
\begin{figure}[h]
  \centering
  \includegraphics[height = 0.3, width = 0.6]{figures/image.pdf}
\end{figure}
```

---

</details>

<details>
  <summary>Aggiungere un riferimento alla bibliografia</summary>

---

Occorre solo modificare il file `biblio.bib` (la bibliografia viene generata automaticamente). Vedi [documentazione](https://www.overleaf.com/learn/latex/Bibliography_management_with_natbib#The_bibliography_file) per altri esempi e specifica del file.

Ad esempio data la bibliografia:
```
@article{donoho,
  author = {Donoho D. L.},
  title = {Compressed Sensing},
  journal = {IEEE Trans. Inf. Theory},
  volume = {52},
  number = {4},
  pages = {1289-1306},
  year = {2006}
}
```

é possibile inserire una citazione nel testo con il comando `\cite`:
```latex
\cite{donoho}
```

---

</details>

### Creazione PDF
Occorre innanzitutto creare una repository personale usando questa come template (vedi [documentazione di Github](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)). La repository personale può quindi essere clonata in locale tramite Git (Git Bash su Windows), ad esempio:

```shell
$ git clone --recursive https://github.com/username/repository
```

> Aprendo la cartella del progetto con Visual Studio Code, alcune estensioni vengono raccomandate per una migliore esperienza di sviluppo/scrittura. É fortemente consigliato installarle.

É possibile entrare in una modalità di **compilazione continua**, che rigenera il PDF ogni volta che un file viene modificato e salvato, tramite uno dei seguenti metodi:
- usare il pulsante " 👁 Sviluppo" nella barra nel lato inferiore della finestra
- eseguire la task "Sviluppo PDF" manualmente da Visual Studio Code
- eseguire `./make watch` nel terminale integrato nell'editor

Per **compilare** singolarmente il progetto in un file PDF é possibile:
- usare il pulsante " ▷ Compila" nella barra nel lato inferiore della finestra
- eseguire la task "Genera PDF" manualmente da Visual Studio Code
- eseguire `./make` nel terminale integrato nell'editor

### FAQ e problemi comuni
<details>
  <summary>Tectonic non supporta immagini EPS</summary>

---

Questo comportamento é voluto dagli autori di Tectonic (vedi [issue su Github](https://github.com/tectonic-typesetting/tectonic/issues/27)). Si consiglia in ogni caso di utilizzare strumenti più moderni, descritti nella sezione "[Editing del testo](#editing-del-testo)".

É possibile comunque convertire immagini da EPS a PDF usando i seguenti parametri per il programma [GhostScript](https://www.ghostscript.com/releases/gsdnld.html):

```
-sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dEPSCrop -o immagine.pdf immagine.eps
```

oppure importandole in programmi di grafica vettoriale come Inkscape ed [esportando come PDF/Latex](https://wiki.inkscape.org/wiki/index.php/LaTeX).

---

</details>

<details>
  <summary><code>Package titlesec Error: Entered in horizontal mode.</code></summary>

---

Il pacchetto `titlesec` potrebbe dare errore di layout **solo con alcuni font alternativi** se non viene utilizzato il comando `\include*` (della libreria `newclude`) per importare i file.

```latex
\include*{chapters/capitolo1}
\include*{chapters/capitolo2}
\include*{chapters/capitolo3}
```

In alternativa, dopo ogni `\include{chapters/...}` deve essere inserita una riga vuota, nella seguente maniera:

```latex
\input{chapters/capitolo1}

\input{chapters/capitolo2}

\input{chapters/capitolo3}
```

---

</details>