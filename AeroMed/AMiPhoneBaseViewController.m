//
//  AMiPhoneBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneBaseViewController.h"
#import "SWRevealViewController.h"
#import "OperatingProcedure.h"

@interface AMiPhoneBaseViewController ()
@property NSMutableArray *documents;

@end

@implementation AMiPhoneBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.documents = [NSMutableArray array];
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    
    // Set the side bar button action to show slide out menu
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self initStandardDocuments];
    
    NSLog(@"Saved document %@", [[self.documents objectAtIndex:0] title]);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create the standard documents
- (void)initStandardDocuments {
    
    OperatingProcedure *alcoholWithdrawal = [OperatingProcedure object];
    alcoholWithdrawal.title = @"Acute Alcohol Withdrawal";
    alcoholWithdrawal.originalDate = @"18 October 2012";
    alcoholWithdrawal.revisedDate = @"18 October 2012";
    alcoholWithdrawal.considerations = @[@"Patient and Crew Safety due to patient anxiety, etc"];
    alcoholWithdrawal.interventions = @[@"Treat withdrawal symptoms aggressively",
                                        @"Anticipate Seizures",
                                        @"Consider associated diagnosis",
                                        @"Head injury",
                                        @"GI Bleed",
                                        @"Infection/Sepsis"];
    alcoholWithdrawal.testsAndStudies = @[@"Blood Alcohol Level",
                                          @"CMP",
                                          @"Head CT",
                                          @"12 Lead ECG"];
    alcoholWithdrawal.medications = @[@"Benzodiazepines",
                                      @"Diprovan (propofol)",
                                      @"Thiamine",
                                      @"Glucose"];
    alcoholWithdrawal.checklist = @[@"Duration/Amount of alcohol ingestion",
                                    @"Time of last alcohol intake",
                                    @"Other substance ingestion"];
    alcoholWithdrawal.impressions = @[@"Acute alcohol withdrawal",
                                      @"Alcohol Dependence",
                                      @"Delirium Tremens",
                                      @"Acute agitation"];
    alcoholWithdrawal.otherConsiderations = nil;
    
    OperatingProcedure *anaphylaxis = [OperatingProcedure object];
    anaphylaxis.title = @"Anaphylaxis";
    anaphylaxis.originalDate = @"18 October 2012";
    anaphylaxis.revisedDate = @"18 October 2012";
    anaphylaxis.considerations = @[@"Consider early airway intervention"];
    anaphylaxis.interventions = @[@"Monitor for hypotension",
                                  @"Prepare for advanced airway intervention"];
    anaphylaxis.testsAndStudies = nil;
    anaphylaxis.medications = @[@"Epinephrine (ensure correct IV bolus/gtt concentration",
                                @"Steroid",
                                @"Benadryl",
                                @"Albuterol",
                                @"Racemic Epinephrine",
                                @"H2 Blocker",
                                @"Vasopresor (if applicable)"];
    anaphylaxis.checklist = @[@"Allergy History",
                              @"Time of onset"];
    anaphylaxis.impressions = @[@"Acute anaphylactic reaction",
                                @"Acute airway obstruction",
                                @"Anaphylactic shock"];
    anaphylaxis.otherConsiderations = nil;
    
    OperatingProcedure *aorticAneurysmDissection = [OperatingProcedure object];
    aorticAneurysmDissection.title = @"Aortic Aneurysm and Dissection";
    aorticAneurysmDissection.originalDate = @"18 October 2012";
    aorticAneurysmDissection.revisedDate = @"18 October 2012";
    aorticAneurysmDissection.considerations = @[@"This is potentially a surgical emergency."
                                                "Being coordination with accepting facility/surgeon ASAP",
                                                @"Take blood into sending facility"];
    aorticAneurysmDissection.interventions = @[@"Keep BP < 120 systolic",
                                               @"Hang blood tubing in anticipation of transfusion"
                                               @"If BP < 90 systolic, transfuse PRBC",
                                               @"Pain/Nausea management",
                                               @"Check pulses and BP in all 4 extremities"];
    aorticAneurysmDissection.testsAndStudies = @[@"Coags",
                                                 @"Hgb",
                                                 @"CT and/or US",
                                                 @"CXR",
                                                 @"Type and Screen",
                                                 @"12 Lead EKG"];
    aorticAneurysmDissection.medications = @[@"Labatelol",
                                             @"----OR----",
                                             @"Nipride"];
    aorticAneurysmDissection.checklist = @[@"Location",
                                           @"CT results",
                                           @"Pulses in all 4 extremities",
                                           @"Blood Pressure Management"];
    aorticAneurysmDissection.impressions = @[@"Abdominal Aneurysm, Ruptured",
                                             @"Abdominal Aneurysm, Without Mention of Rupture",
                                             @"Dissection of Aorta, unspecified site"];
    aorticAneurysmDissection.otherConsiderations = @[@"Typing Systems Include:",
                                                     @"DeBakey (Type I, II, III)",
                                                     @"Stanford (Type A & B)",
                                                     @"Treatment may vary (surgical versus medical)"
                                                     "depending on aneurysm location"];
    
    OperatingProcedure *unstableArrhythmias = [OperatingProcedure object];
    unstableArrhythmias.title = @"Unstable Arrhythmias";
    unstableArrhythmias.originalDate = @"18 October 2012";
    unstableArrhythmias.revisedDate = @"18 October 2012";
    unstableArrhythmias.considerations = @[@"Stabilize prior to transport",
                                           @"Notify PIC prior to defibrillation/cardioversion"];
    unstableArrhythmias.interventions = @[@"Utilize ACLS/PALS/NRP guidelines",
                                          @"Place defibrillation pads",
                                          @"Cardiovert, defibrillate, pace when appropriate",
                                          @"Airway management",
                                          @"Medication administration"];
    unstableArrhythmias.testsAndStudies = @[@"12 Lead ECG",
                                            @"Electrolytes"];
    unstableArrhythmias.medications = @[@"ACLS / PALS / NRP"];
    unstableArrhythmias.checklist = @[@"Response to interventions",
                                      @"Printed ECG strips",
                                      @"Time of onset"];
    unstableArrhythmias.impressions = @[@"Arrhythmia type",
                                        @"Identify cause",
                                        @"Other Symptoms (Chest Pain, Nausea, etc.)"];
    unstableArrhythmias.otherConsiderations = nil;
    
    OperatingProcedure *arterialOcclusion = [OperatingProcedure object];
    arterialOcclusion.title = @"Arterial Occlusion";
    arterialOcclusion.originalDate = @"18 October 2012";
    arterialOcclusion.revisedDate = @"18 October 2012";
    arterialOcclusion.considerations = @[@"Transport with affected extremity in position of comfort",
                                         @"This is a surgically urgent/emergent diagnosis",
                                         @"Pulses via Doppler",
                                         @"Examine for changes ruing transport"
                                         "(worsening or loss of pulses)"];
    arterialOcclusion.interventions = @[@"Pain control",
                                        @"Anticoagulants as directed by vascular surgeon",
                                        @"Oxygen"];
    arterialOcclusion.testsAndStudies = @[@"Angiogram",
                                          @"Coags"];
    arterialOcclusion.medications = @[@"Heparin/Lovenox",
                                      @"Aspirin"];
    arterialOcclusion.checklist = @[@"INR",
                                    @"Ischemia time",
                                    @"Vascular assessement"];
    arterialOcclusion.impressions = @[@"Arterial Embolism and Thrombosis of Unspecified Artery",
                                      @"Pain, acute"];
    arterialOcclusion.otherConsiderations = nil;
    
    OperatingProcedure *asthmaAndCOPD = [OperatingProcedure object];
    asthmaAndCOPD.title = @"Asthma and COPD";
    asthmaAndCOPD.originalDate = @"18 October 2012";
    asthmaAndCOPD.revisedDate = @"18 October 2012";
    asthmaAndCOPD.considerations = @[@"Ensure adequate amount of nebulizer medications for transport",
                                     @"If on Heliox must be transported by ground with RT"];
    asthmaAndCOPD.interventions = @[@"Airway management",
                                    @"Medication administration",
                                    @"Use of asthma/COPD ase ventilator settings (PEEP 0-5)",
                                    @"Consider BIPAPA -vs- Intubation",
                                    @"Beware of auto-PEEP and pneumothorax during air transport phase"];
    asthmaAndCOPD.testsAndStudies = @[@"CXR",
                                      @"ABG"];
    asthmaAndCOPD.medications = @[@"Nebulizers",
                                  @"Steroid",
                                  @"IVF (hold with COPD)",
                                  @"Magnesium",
                                  @"Ketamine",
                                  @"HeliOx"];
    asthmaAndCOPD.checklist = @[@"History",
                                @"Previous intubation",
                                @"Home medication/O2 Therapy",
                                @"Frequency of Exacerbations",
                                @"Code Status (COPD)"];
    asthmaAndCOPD.impressions = @[@"Acute Asthma Exacerbations",
                                  @"Acute COPD Exacerbations",
                                  @"Respiratory Failure/Distress",
                                  @"Status Asthmaticus"];
    asthmaAndCOPD.otherConsiderations = @[@"Status Asthmaticus with Arrest",
                                          @"1. Disconnect Ventilator",
                                          @"2. Manual compression of chest",
                                          @"3. Bilateral Chest Tubes"];
    
    OperatingProcedure *carbonMonoxidePoisoning = [OperatingProcedure object];
    carbonMonoxidePoisoning.title = @"Carbon Monoxide Poisoning";
    carbonMonoxidePoisoning.originalDate = @"18 October 2012";
    carbonMonoxidePoisoning.revisedDate = @"18 October 2012";
    carbonMonoxidePoisoning.considerations = @[@"Appropriate Receiving Facility (consider HBO)",
                                               @"Anticipate multiple patients",
                                               @"Ensure adequate oxygen availability for transport"];
    carbonMonoxidePoisoning.interventions = @[@"100% NRB or 100% FIO2 if intubated or CPAP",
                                              @"Screen for pregnancy, cardiac signs and symptoms"];
    carbonMonoxidePoisoning.testsAndStudies = @[@"ABG (with CO levels)",
                                                @"12 Lead EKG",
                                                @"Cardiac Enzymes (>65 years)"];
    carbonMonoxidePoisoning.medications = @[@"Oxygen"];
    carbonMonoxidePoisoning.checklist = @[@"Route and FIO2 of Oxygen Administration",
                                          @"CO Level",
                                          @"Level of Consciousness"];
    carbonMonoxidePoisoning.impressions = @[@"Carbon Monoxide Poisoning",
                                            @"Toxic Effect of Carbon Monoxide"];
    carbonMonoxidePoisoning.otherConsiderations = @[@"Consider accidental versus intentional cause",
                                                    @"Consider other possible toxic exposure (Cyanide, polydrug)"];
    
    OperatingProcedure *cardiacArrest = [OperatingProcedure object];
    cardiacArrest.title = @"Cardiac Arrest / Arrest After Flight Team Arrival";
    cardiacArrest.originalDate = @"18 October 2012";
    cardiacArrest.revisedDate = @"18 October 2012";
    cardiacArrest.considerations = @[@"Do NOT life if patient is an adult in Cardiac Arrest",
                                     @"May consider lift if pediatric",
                                     @"Follow ACLS/PALS/NRP guidelines",
                                     @"If arrest occurs during transport phase and unnsuccessful in ROSC",
                                     @"During loading phase return to ED",
                                     @"During flight phase:",
                                     @"Consider continuing to destination and divert to ED",
                                     @"Notify flight communications and request additional help on helistop",
                                     @"Notify PIC prior to defibrillation or cardioversion"
                                     @"Do not attempt during takeoff or landing"];
    cardiacArrest.interventions = @[@"Place pads on all patients who are unstable",
                                    @"Consider therapeutic hypothermia protocol if ROSC",
                                    @"Consider causes of arrest"];
    cardiacArrest.testsAndStudies = nil;
    cardiacArrest.medications = @[@"Per ACLS/PALS/NRP guidelines"];
    cardiacArrest.checklist = @[@"Time of onset",
                                @"Any prior arrests",
                                @"Reason for termination",
                                @"All interventions",
                                @"Printed ECG strips"];
    cardiacArrest.impressions = @[@"Cardiopulmonary arrest",
                                  @"Underlying cause (of cardiac arrest)"];
    cardiacArrest.otherConsiderations = @[@"Discuss code status and possible diversion with "
                                          "family prior to departure if arrest anticipated",
                                          @"See Declaration of Death Cessation of Resuscitation Efforts SOP"];
    
    OperatingProcedure *congestiveHeart = [OperatingProcedure object];
    congestiveHeart.title = @"Congestive Heart Failure and Pulmonary Edema";
    congestiveHeart.originalDate = @"18 October 2012";
    congestiveHeart.revisedDate = @"18 October 2012";
    congestiveHeart.considerations = @[@"Transport in a position of comfort (HOB elevated)"];
    congestiveHeart.interventions = @[@"Supplemental 02 vs BIPAP vs Intubation",
                                      @"BP control (Nitrates and Morphine)",
                                      @"Diurese",
                                      @"Foley (monitor output)"];
    congestiveHeart.testsAndStudies = @[@"CXR",
                                        @"12 Lead EKG",
                                        @"CBC",
                                        @"CMP",
                                        @"BNP"];
    congestiveHeart.medications = @[@"Nitrates",
                                    @"Diuretics if volume overload"];
    congestiveHeart.checklist = @[@"BNP",
                                  @"CXR Interpretation"];
    congestiveHeart.impressions = @[@"CHF Exacerbation",
                                    @"Pulmonary Edema",
                                    @"Respiratory Distress/Failure",
                                    @"Hypoxia"];
    congestiveHeart.otherConsiderations = nil;
    
    OperatingProcedure *intravascularCoagulation = [OperatingProcedure object];
    intravascularCoagulation.title = @"Disseminated Instravascular Coagulation";
    intravascularCoagulation.originalDate = @"18 October 2012";
    intravascularCoagulation.revisedDate = @"18 October 2012";
    intravascularCoagulation.considerations = @[@"Determine need for blood products (e.g. FFP) and consider "
                                                "obtaining from SHBWH prior to arrival at sending hospital",
                                                @"Consultation with Obstetrician prior to launch and/or "
                                                "during appropriate phases of transport (if applicable)"];
    intravascularCoagulation.interventions = @[@"Correct coagulopathy only if at high risk for bleeding, active "
                                               "bleeding or prior to required invasive procedure",
                                               @"Treate underlying disease/cause",
                                               @"Examples: Sepsis, Retained products of conception"];
    intravascularCoagulation.testsAndStudies = @[@"Coags",
                                                 @"D-Dimer",
                                                 @"CBC"];
    intravascularCoagulation.medications = @[@"Antibiotics",
                                             @"Blood products",
                                             @"Vitamin K",
                                             @"Heparing (consider with consultation)"];
    intravascularCoagulation.checklist = @[@"Bleeding sites/amount",
                                           @"Underlying cause"];
    intravascularCoagulation.impressions = @[@"Disseminated Intravascular Coagulation",
                                             @"Sepsis",
                                             @"Complications of pregnancy",
                                             @"Coagulopathy"];
    intravascularCoagulation.otherConsiderations = @[@"Avoid invasive procedures (consider risk/benefit)"];
    
    

    // Add all documents
    [self.documents addObject:alcoholWithdrawal];
    [self.documents addObject:anaphylaxis];
    [self.documents addObject:aorticAneurysmDissection];
    [self.documents addObject:unstableArrhythmias];
    [self.documents addObject:arterialOcclusion];
    [self.documents addObject:asthmaAndCOPD];
    [self.documents addObject:carbonMonoxidePoisoning];
    [self.documents addObject:cardiacArrest];
    [self.documents addObject:congestiveHeart];
    [self.documents addObject:intravascularCoagulation];
    
    
    
}

- (IBAction)didTap1:(id)sender {
    if ([self.check1.titleLabel.text length] == 0){
        [self.check1 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check1 setTitle:@""
                 forState:UIControlStateNormal];
    }
}

- (IBAction)didTap2:(id)sender{
    if ([self.check2.titleLabel.text length] == 0){
        [self.check2 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check2 setTitle:@""
                 forState:UIControlStateNormal];
    }
}

- (IBAction)didTap3:(id)sender{
    if ([self.check3.titleLabel.text length] == 0){
        [self.check3 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check3 setTitle:@""
                 forState:UIControlStateNormal];
    }
}
@end
