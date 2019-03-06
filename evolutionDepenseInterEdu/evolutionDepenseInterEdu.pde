FloatTable donnees;
float dmin, dmax;
int amin, amax;
int[] annees;
float traceX1, traceY1, traceX2, traceY2;
// La colonne de données actuellement utilisée.
int colonne = 0;
// Le nombre de colonnes.
int ncol;
// La police de caractères.
PFont police;
int intervalleAnnees = 1;
int intervalleVolume = 1;
int lignes;
Integrator[] inter;

void setup() {
   //  size(820, 505);
   fullScreen(P3D);

    donnees = new FloatTable("evolution.tsv");
    ncol = donnees.getColumnCount(); 
    lignes = donnees.getRowCount();
   
    dmin = 0;
    dmax = donnees.getTableMax();
    annees = int(donnees.getRowNames());
    amin = annees[0];
    amax = annees[annees.length - 1];

    traceX1 = 120;
    traceY1 = 50;
    traceX2 = width - traceX1;
    traceY2 = height - traceY1;

    police = createFont("SansSerif", 20);
    textFont(police);
  
  inter = new Integrator[lignes];
    for (int row = 0; row < lignes; row++) {
      float initialValue = donnees.getFloat(row, colonne);
      inter[row] = new Integrator(initialValue);
      inter[row].attraction = 0.1;
    }
    smooth();
    


}

void draw() {
    
    background(224);
    // Dessine le fond.
    fill(255);
    rectMode(CORNERS);
    noStroke();
    translate(width/50, height/100);

    rect(traceX1, traceY1, traceX2, traceY2);
    
    for (int row = 0; row < lignes; row++) { 
      inter[row].update( );
    }
    
    dessineTitre();
    dessineAxeAnnees();
    dessineAxeVolume();
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
        //translate(width/20, height/100);

    dessineLigneDonnees(colonne);
    strokeWeight(5);
    stroke(#5679C1);
    dessinePointsDonnees(colonne);
    textAlign( CENTER);
    textSize(15);
    fill(180,133,13);
    text(" Evolution\n de la dépense\n intérieure\n d'éducation \npar niveau \nd'enseignement .", 30,500);
    text("Années", 950,1060);

 }


void dessinePointsDonnees(int col) {
  choixCouleur(col);
      strokeWeight(10);
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = inter[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            point(x, y);
        }
    }
}

void dessineAxeAnnees() {
    fill(0);
    textSize(10);
    textAlign(CENTER, TOP);

    // Des lignes fines en gris clair.
    stroke(224);
    strokeWeight(1);

    for(int ligne = 0; ligne < lignes; ligne++) {
        if(annees[ligne] % intervalleAnnees == 0) {
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            text(annees[ligne], x, traceY2 + 10);
            // Dessine les lignes.
            line(x, traceY1, x, traceY2);
        }
    }
}

void dessineTitre() {
    fill(180,133,13);
    textSize(20);
    textAlign(LEFT);
    text(donnees.getColumnName(colonne), traceX1, traceY1 - 10); 
    fill(0);
    text("Apuiyez sur n'importe quelle touche a part la touche echap pour défilé les courbes ..." , traceX1+450, traceY1 - 10); 

}

void dessineAxeVolume() {
    fill(0);
    textSize(10);
    textAlign(RIGHT, CENTER);
    for(float v = dmin; v < dmax; v+= intervalleVolume) {
        float y = map(v, dmin, dmax, traceY2, traceY1);
        text(floor(v), traceX1 - 10, y);
    }
}

void dessineLigneDonnees(int col) { 
 choixCouleur(col);
  float valeur;
    beginShape();   // On commence la ligne.
    strokeWeight(3);
    for(int ligne = 0; ligne < lignes; ligne++) {  
        if(donnees.isValid(ligne, col)) {
             valeur =inter[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            vertex(x, y);
            
        }

    }
    endShape(); // On termine la ligne sans fermer la forme.
}

 void  genererNiveauEnsseignement(){
       colonne++;
      if (colonne >=ncol) colonne=0;
      
      for (int row = 0; row < lignes; row++) {
    inter[row].target(donnees.getFloat(row, colonne));
  }

}

void keyPressed() {
    genererNiveauEnsseignement();
}

void choixCouleur(int col){
    switch(col){
    case  0 :     stroke( #4422CC);
    break;
    case  1 :     stroke(21,234,97);
        break;
    case  2 :     stroke(221,21,232); 
        break;
    case  3 :      stroke(232,215,21);
        break;
    case  4 :      stroke(93,100,93);
        break;
    
  }
}
