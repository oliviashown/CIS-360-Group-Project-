CREATE TABLE DOI (
    doi_address varchar(70) PRIMARY KEY,
    doi_title varchar(200),
    -- author
    pub_date varchar(10),
    doi_url varchar(100),
    -- keywords
    abstract TEXT,
    publisher varchar(20),
    field varchar(50)
);
CREATE TABLE FUSION_METHOD (
    m_name varchar(100),
    m_key varchar(100) PRIMARY KEY,
    m_doi varchar(70),
    m_desc TEXT,
    u1 TEXT,
    u3 TEXT
);

CREATE TABLE DATA (
  d_doi varchar(70),
  d_name varchar(70) PRIMARY KEY,
  d_url varchar(100),
  method_key varchar(100),
  d_type varchar(50),
  collection_method varchar(50),
  u2 TEXT,
  spatial_coverage varchar(25),
  temporal_coverage varchar(25),
  format varchar(10),
  license varchar(10),
  provenance varchar(100),
  FOREIGN KEY (d_doi) REFERENCES DOI(doi_address),
  FOREIGN KEY (method_key) REFERENCES FUSION_METHOD(m_key)
);
CREATE TABLE DOI_AUTHOR(
    a_doi varchar(70),
    author varchar(50),
    PRIMARY KEY (a_doi, author),
    FOREIGN KEY (a_doi) REFERENCES DOI(doi_address)
);

-- Table: DOI
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.inffus.2023.102140', 'Fake news detection: Taxonomy and comparative study', '2024', 'https://www.sciencedirect.com/science/article/pii/S1566253523004566', 'The paper proposes an updated taxonomy for automatic fake news detection and conducts an extensive empirical study evaluating 15 feature representation techniques and 20 classification algorithms acro', 'Elsevier', 'Artificial Intelligence / Machine Learning / Natur');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.inffus.2023.102084', 'Global-local fusion based on adversarial sample generation for image-text matching', '2024', 'https://www.sciencedirect.com/science/article/pii/S1566253523004001', 'This paper addresses the vulnerability of image-text matching models to adversarial attacks. It proposes a novel framework that generates adversarial samples to train a more robust model. The core of', 'Elsevier', 'Computer Vision / Artificial Intelligence');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.inffus.2023.102076', 'Lightweight and smart data fusion approaches for wearable devices of the Internet of Medical Things', '2024', 'https://www.sciencedirect.com/science/article/pii/S1566253523003925', 'The paper presents a two-tier lightweight data fusion approach consisting of local in-node processing at the device level and global non-metric-based fusion at the server level. It aims to refine phys', 'Elsevier', 'Internet of Medical Things (IoMT) / Smart Healthca');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.ipm.2023.103538', 'Coordinated-joint translation fusion framework with sentiment-interactive graph convolutional networks for multimodal sentiment analysis', '2024', 'https://www.sciencedirect.com/science/article/pii/S0306457323002753', 'This paper proposes a Coordinated-Joint Translation Fusion (CJTF) framework to address the limitations of treating modalities equally in sentiment analysis. It utilizes a Sentiment-Interactive Graph C', 'Elsevier', 'Natural Language Processing / Multimodal Intellige');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.autcon.2023.105156', 'Deep learning-based text detection and recognition on architectural floor plans', '2024', 'https://www.sciencedirect.com/science/article/pii/S0926580523004168', 'This paper presents a specialized text extraction approach for architectural floor plans using a deep learning-based object detection model (YOLOv8) and state-of-the-art Optical Character Recognition', 'Elsevier', 'Architecture / Civil Engineering / Computer Scienc');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.2196/21926', 'Deep Learning-Based Multimodal Data Fusion: Case Study in Food Intake Episodes Detection Using Wearable Sensors', '2021', 'https://mhealth.jmir.org/2021/1/e21926/', 'Background: Multimodal wearable technologies have brought forward wide possibilities in human activity recognition, and more specifically personalized monitoring of eating habits. The emerging challen', 'JMIR MHEALTH AND UHE', 'Human Activity Recognition');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1093/toxsci/kfaa187', 'Assessment of Mechanistic Data for Hexavalent Chromium-Induced Rodent Intestinal Cancer Using the Key Characteristics of Carcinogens', '2021', 'https://academic.oup.com/toxsci/article/180/1/38/6066197', 'Oral exposure to hexavalent chromium (Cr[VI]) induces intestinal tumors in mice. Mutagenic and nonmutagenic modes of action (MOAs) have been accepted by different regulatory bodies globally, the latte', 'Oxford University Pr', 'Toxicology / Oncology');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1109/ACCESS.2021.3090436', 'Improving the Performance of Infrared and Visible Image Fusion Based on Latent Low-Rank Representation Nested With Rolling Guided Image Filtering', '2021', 'https://ieeexplore.ieee.org/document/9459693', 'The fusion quality of infrared and visible image is very important for subsequent human understanding of image information and target processing. The fusion quality of the existing infrared and visibl', 'IEEE', 'Computer Vision');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.3390/en14020468', 'Building Suitable Datasets for Soft Computing and Machine Learning Techniques from Meteorological Data Integration: A Case Study for Predicting Significant Wave Height and Energy Flux', '2021', 'https://www.mdpi.com/1996-1073/14/2/468', 'Meteorological data are extensively used to perform environmental learning. Soft Computing ({SC}) and Machine Learning ({ML}) techniques represent a valuable support in many research areas, but requir', 'MDPI', 'Environmental Engineering');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.neunet.2020.10.003', 'DMMAN: A two-stage audio-visual fusion framework for sound separation and event localization', '2020', 'https://www.sciencedirect.com/science/article/abs/pii/S0893608020303580?via%3Dihub', 'Videos are used widely as the media platforms for human beings to touch the physical change of the world. However, we always receive the mixed sound from the multiple sound objects, and cannot disting', 'Elsevier', 'AI / Signal Processing');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.bspc.2021.103140', 'Image fusion algorithm based on unsupervised deep learning-optimized sparse representation', '2022', 'https://doi.org/10.1016/j.bspc.2021.103140', 'The image fusion method based on deep learning has problems such as the supervised learning of the model, the edge and noise of the fused image, and the setting of the image fusion weight map. To solv', 'Elsevier', 'Biomedical Engineering');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.3390/rs13204021', 'Two-Stream Deep Fusion Network Based on VAE and CNN for Synthetic Aperture Radar Target Recognition', '2021', 'https://doi.org/10.3390/rs13204021', 'Usually radar target recognition methods only use a single type of high-resolution radar signal, e.g., high-resolution range profile ({HRRP}) or synthetic aperture radar ({SAR}) images. In fact, in th', 'MDPI', 'Remote Sensing');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1007/s12161-021-02113-1', 'Improving Intramuscular Fat Assessment in Pork by Synergy Between Spectral and Spatial Features in Hyperspectral Image', '2022', 'https://doi.org/10.1007/s12161-021-02113-1', 'Meat is a complex matrix of structural features exhibiting physical and chemical variations. The duality of the spatial and spectral information in the hyperspectral image of meat provides complementa', 'Springer', 'Food Science');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.eswa.2021.115879', 'COVID19-HPSMP: COVID-19 adopted Hybrid and Parallel deep information fusion framework for stock price movement prediction', '2022', 'https://doi.org/10.1016/j.eswa.2021.115879', 'The novel of coronavirus ({COVID}-19) has suddenly and abruptly changed the world as we knew at the start of the 3rd decade of the 21st century. Particularly, {COVID}-19 pandemic has negatively affect', 'Elsevier', 'Financial Econometrics');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.displa.2021.102082', 'RAFNet: RGB-D attention feature fusion network for indoor semantic segmentation', '2021', 'https://doi.org/10.1016/j.displa.2021.102082', 'Semantic segmentation based on the complementary information from {RGB} and depth images has recently gained great popularity, but due to the difference between {RGB} and depth maps, how to effectivel', 'Elsevier', 'Imaging Science');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1093/bioinformatics/btab664', 'timeOmics: an R package for longitudinal multi-omics data integration', '2022', 'https://academic.oup.com/bioinformatics/article/38/2/577/6374493', 'Introduces a generic analytical framework for the integration of longitudinal multi-omics data (mRNA, metabolites, etc.) to identify molecular features associated with time.', 'Oxford University Pr', 'Bioinformatics');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.cct.2021.106526', 'Testing the effectiveness of community-engaged citizen science to promote physical activity, foster healthier neighborhood environments, and advance health equity in vulnerable communities: The Steps', '2021', 'https://www.sciencedirect.com/science/article/pii/S1551714421002627?via%3Dihub', 'A cluster-randomized controlled trial design comparing person-level physical activity interventions against citizen science-driven neighborhood interventions.', 'Elsevier', 'Public Health / Clinical Trials');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1109/MAES.2021.3070884', 'Space-Based Global Maritime Surveillance. Part II: AI and Data Fusion Techniques', '2021', 'https://www.google.com/url?sa=E&source=gmail&q=https://doi.org/10.1109/MAES.2021.3070884', 'Part II of a study focusing on artificial intelligence and data fusion techniques specifically for global maritime tracking using space-based sensors.', 'IEEE', 'Aerospace / Maritime Surveillance');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1128/mSphere.00614-21', 'A Prioritized and Validated Resource of Mitochondrial Proteins in Plasmodium...', '2021', 'https://doi.org/10.1128/mSphere.00614-21', 'Integrates eight diverse data sets including gene expression, orthology, and amino acid sequences into a predictive score for protein localization.', 'American Society for', 'Molecular Biology / Bioinformatics');
INSERT INTO DOI (doi_address, doi_title, pub_date, doi_url, abstract, publisher, field) VALUES ('10.1016/j.inffus.2021.07.019', 'Proposal-Copula-Based Fusion of Spaceborne and Airborne SAR Images...', '2022', 'https://doi.org/10.1016/j.inffus.2021.07.019', 'Proposes a new method (TPCT) for fusing synthetic aperture radar (SAR) images from spaceborne and airborne sensors to improve target-to-clutter ratios.', 'Elsevier', 'Remote Sensing / Image Processing');

-- Table: FUSION_METHOD
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Transformer-Feature Extraction Fusion (TFEF)', '7b8c9d0e-1f2a-4b3c-5d6e-7f8a9b0c1d2e', '10.1016/j.inffus.2023.102140', 'A multi-stage fusion framework that extracts contextualized embeddings from various transformer architectures (e.g., BERT, LLaMA) and feeds them into traditional ML or Deep Learning classifiers (SVM,', 'The selection of specific transformer layers for extraction remains heuristic; the paper notes uncer', 'TFEF outperformed end-to-end fine-tuning in most scenarios. Specifically, using Falcon as a feature');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Global-Local Dynamic Fusion (GLDF)', 'a2b3c4d5-e6f7-4b8c-9d0e-1f2a3b4c5d6e', '10.1016/j.inffus.2023.102084', 'A multi-modal fusion strategy that employs an adversarial sample generation network to produce "hard" examples. It uses a dynamic fusion gate to adaptively weight and combine global context embeddings', 'Uncertainty exists regarding the optimal ratio of adversarial to clean samples during training. The', 'The GLDF method significantly improved R@1 (Recall at 1) metrics on Flickr30K and MS-COCO datasets.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Two-Tier Lightweight IoMT Fusion', 'e1f2a3b4-c5d6-4e7f-8g9h-0i1j2k3l4m5n', '10.1016/j.inffus.2023.102076', 'A hierarchical approach combining local in-node processing (Euclidean distance-based) and global server-level fusion (Longest Common Subsequence - LCSS). It includes mechanisms for signal padding (mea', 'The threshold value ($\delta$) for determining outliers is an application-dependent parameter that v', 'Simulation results show exceptional performance in accuracy and precision ratios. The approach succe');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Coordinated-Joint Translation Fusion (CJTF)', 'b1e2a3f4-c5d6-4e7b-8a9c-0d1e2f3a4b5c', '10.1016/j.ipm.2023.103538', 'A hierarchical fusion framework that uses Cross-modal Masked Attention (CMA) to distinguish semantic contributions and a Translation-aware Mechanism to map non-textual features (video/audio) into a sh', 'There is uncertainty in the "translation" process regarding the potential loss of modality-specific', 'The CJTF framework achieved state-of-the-art results on the MOSI and MOSEI datasets. It demonstrated');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('YOLO-OCR Hybrid Detection Pipeline', 'c3d4e5f6-a7b8-4c9d-1e2f-3a4b5c6d7e8f', '10.1016/j.autcon.2023.105156', 'A two-stage fusion approach where a YOLOv8 object detection model identifies and crops text-related bounding boxes (e.g., room names, dimensions), which are then processed by a selected OCR engine (Pa', 'There is significant uncertainty regarding the model''s ability to handle "hand-drawn" historical flo', 'The study found that YOLOv8 combined with PaddleOCR achieved the highest F1-score. The proposed data');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Deep Learning–Based Multimodal Data Fusion', '9f2a4c8b-d0e1-4f2a-9b3c-4d5e6f7a8b9c', '10.2196/21926', 'This paper, published in JMIR mHealth and uHealth, proposes a novel deep learning-based sensor fusion technique designed to detect food intake (eating episodes) using multimodal data from wearable dev', 'Human activities like "eating" are complex and vary between individuals; defining where an activity', 'High-dimensional raw data is often too "heavy" for wearable devices to process, leading to latency o');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Key Characteristics of Carcinogens (KCC) approach', '2b3c4d5e-6f7a-8b9c-d0e1-f2a3b4c5d6e7', '10.1093/toxsci/kfaa187', 'This paper evaluates whether alternative biological pathways (like epigenetics or immunosuppression) contribute to hexavalent chromium-induced intestinal cancer in rodents. Using the Key Characteristi', 'The researchers used the KCC method to see if a more "holistic" abstraction would reveal a new "real', 'This paper addresses algorithmic processing errors by proposing a cluster-based saliency method. The');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('LatLRR nested with RGIF', 'd4e5f6a7-b8c9-d0e1-f2a3-b4c5d6e7f8a9', '10.1109/ACCESS.2021.3090436', 'This paper proposes a novel image fusion method that combines Latent Low-Rank Representation (LatLRR) and Rolling Guided Image Filtering (RGIF) to merge infrared and visible images. It effectively rem', 'Simplification of grid variables or climatic abstraction used in the model''s conception.', 'This uncertainty stems from Algorithmic Assumptions within the optimization or simulation models use');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('SC/ML Dataset Tool', 'e1f2a3b4-c5d6-4e7b-8a9c-0d1e2f3a4b5c', '10.3390/en14020468', 'This paper introduces SPAMDA, an open-source software tool designed to automate the integration and pre-processing of meteorological data from NDBC buoys and NNRP reanalysis grids. It streamlines the', 'The abstraction process in the SPAMDA tool involves a complex mapping where continuous physical phen', 'The algorithmic uncertainty stems from the Stochastic Nature of the Evolutionary Algorithm. Because');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Deep Multi-Modal Attention Network', 'f7a8b9c0-d1e2-4f3a-b4c5-d6e7f8a9b0c1', '10.1016/j.neunet.2020.10.003', 'The DMMAN is a two-stage audio–visual fusion framework designed to separate individual sound sources and localize visual events within unconstrained videos. By utilizing a multi-modal separator and a', 'Abstraction of physical laws into constraints.', 'Analytical integrity depends on the validity of algorithmic assumptions, such as linearity or statio');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Optimized Sparse Representation (SR)', '25e1bc16-75a9-4d56-ac62-f92ebd71dd57', '10.1016/j.bspc.2021.103140', 'Method dividing images into target and background areas for sparse coding.', 'Sensitivity to target/background division parameters.', 'Robustness to noise depends on dictionary completeness.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Super Complete Dictionary Learning', '9055532c-d938-4b8c-b720-eaf3bc2b8435', '10.1016/j.bspc.2021.103140', 'Learning process to obtain a sparse representation of the image background area.', 'Dimensionality and convergence of the dictionary learning process.', 'Computational cost of learning from noise-heavy backgrounds.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('One-to-Many Focus Image Fusion', '8afeaff3-60fb-4639-8f6c-9d09b301d768', '10.1016/j.bspc.2021.103140', 'Fusing multiple multi-focus images into a single all-focus result.', 'Registration errors between multiple source images.', 'Loss of texture at focus boundaries.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('End-to-End Two Stream Fusion Network', '768d5187-a3b9-4f6e-bbef-176d7b5a809f', '10.3390/rs13204021', 'Proposed network integrating 1D and 2D radar signal characteristics.', 'Stream synchronization and modality weighting.', 'Classifier performance on similar target geometries.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Variational Auto-Encoder (VAE) Network', '9cf9a596-8435-407d-b7ee-c7155a3b466e', '10.3390/rs13204021', 'Network path to acquire latent probabilistic distributions from HRRP data.', 'Stochastic latent space sampling.', 'Loss of signal variance in 1D encoding.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('LightNet (CNN Stream)', '47dde933-2ff6-4fd8-a892-8a43837ab29f', '10.3390/rs13204021', 'Lightweight CNN used to extract 2D visual structure characteristics from SAR images.', 'Limited receptive field of lightweight layers.', 'Sensitivity to SAR speckle noise.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Low-level Data Fusion (Hyperspectral)', '9ec75af9-6de4-40ad-9dbe-74fe3667daee', '10.1007/s12161-021-02113-1', 'Fusing raw spectral and textural data at the observation level.', 'Scale incompatibility between pixels and spectra.', 'Curse of dimensionality.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Mid-level Data Fusion (Hyperspectral)', '60aa9e1e-e2c5-41ca-9009-927b88851550', '10.1007/s12161-021-02113-1', 'Fusing extracted spectral and spatial features (synergistic fusion).', 'Feature selection bias.', 'Inter-feature correlation masking information.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('High-level Data Fusion (Hyperspectral)', '76ea6bf9-5f4d-4270-a5b0-9d7ed2f21c8a', '10.1007/s12161-021-02113-1', 'Fusing model decisions from individual spectral and spatial predictors.', 'Decision weighting uncertainty.', 'Consensus may ignore valid local spectral anomalies.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('COVID19-HPSMP', 'd2cac3dd-bce2-4520-8f46-efb676f87b3d', '10.1016/j.eswa.2021.115879', 'Hybrid and Parallel deep fusion framework for stock prediction.', 'Coordination between parallel paths.', 'Market volatility sensitivity.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Multilayer Fusion', 'fcd3fc50-5268-4924-9fe6-8397976847af', '10.1016/j.eswa.2021.115879', 'Fusion center combining localized and sequential features from both paths.', 'Feature dimensionality mismatch.', 'Aggregation bias.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('RAFNet', '18a95e8c-cb06-488c-95f7-e696b94c8f42', '10.1016/j.displa.2021.102082', 'RGB-D attention feature fusion network for indoor semantic segmentation.', 'Selection of attention module architectures.', 'Performance varies across indoor scene types.');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Longitudinal sPLS and Clustering', '92f8a1e2-b1c3-4d4e-a5f6-7b8c9d0e1f2a', '10.1093/bioinformatics/btab664', 'Fuses longitudinal mRNA, metabolite, and clinical data to model biological dynamics over time.', 'Ambiguity in the definition of ''longitudinal biological association'' across diverse omic layers with', 'Analytical assumptions regarding linear relationships in sPLS modeling and sensitivity to the choice');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Methodological Fusion (ALED + Our Voice)', 'c3d4e5f6-a7b8-4c9d-8e0f-1a2b3c4d5e6f', '10.1016/j.cct.2021.106526', 'Integrates objective physical activity measurements with community-sourced environmental data.', 'Subjectivity in how citizen scientists define and abstract environmental ''barriers'' and ''facilitator', 'Difficulty in statistical integration between objective accelerometry trends and qualitative, text-b');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('JDL Fusion Architecture', 'd4e5f6a7-b8c9-4d0e-9f1a-2b3c4d5e6f7a', '10.1109/MAES.2021.3070884', 'Fuses heterogeneous satellite sensor data for real-time maritime tracking and vessel identification.', 'Vagueness in defining what constitutes an ''anomalous vessel behavior'' across different maritime oper', 'Latency and error propagation issues when merging high-velocity AIS reporting data with lower-freque');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Bayesian Statistical Evidence Integration', 'e5f6a7b8-c9d0-4e1f-8a2b-3c4d5e6f7a8b', '10.1128/mSphere.00614-21', 'Integrates eight disparate biological data sources to classify protein localization in malaria parasites.', 'Uncertainty regarding the conceptual completeness of the mitochondrial proteome across different lif', 'Potential for biased predictions based on the subjective selection of prior probabilities for the ei');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Copula-based Joint PDF Modeling (TPCT)', 'f6a7b8c9-d0e1-4f2a-9b3c-4d5e6f7a8b9c', '10.1016/j.inffus.2021.07.019', 'Fuses SAR images from different altitudes (space vs. air) to enhance signal-to-clutter ratio for detection.', 'Discrepancies in the conceptual representation of ship targets when viewed from spaceborne versus ai', 'Variation in image fusion quality; the Copula-based model performs significantly better on low-frequ');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('CNN-LSTM Hybrid Fusion', 'a7b8c9d0-e1f2-4a3b-8c4d-5e6f7a8b9c0d', '10.1016/j.envsoft.2022.105412', 'Fuses temporal sensor trends with spatial city layout data to predict local pollution levels.', 'Ambiguity in defining "local neighborhood influence" and how spatial city layouts are abstracted int', 'Model is sensitive to multi-task trade-off issues (currently set to 1:1); results may not be applica');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Feature-level Random Forest Fusion', 'b8c9d0e1-f2a3-4b4c-9d5e-6f7a8b9c0d1e', '10.1016/j.isprsjprs.2021.08.015', 'Combines radar backscatter and multispectral reflectance to classify complex urban environments.', 'Uncertainty in the semantic classification of "complex urban environments"—where boundaries between', 'R^2 metrics range between 0.7-0.8, indicating the model is good but not completely reliable; street-');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Semantic-Spatial Data Fusion', 'c9d0e1f2-a3b4-4c5d-0e6f-7a8b9c0d1e2f', '10.1016/j.cageo.2021.104880', 'Fuses social media reports (unstructured) with satellite imagery (structured) to identify flood extents.', 'Subjectivity in social media reports; what a user defines as a "flood" varies significantly compared', 'Algorithmic difficulty in aligning unstructured, geotagged text with structured pixel data; high var');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Spatio-temporal Digital Twin Fusion', 'd0e1f2a3-b4c5-4d6e-1f7a-8b9c0d1e2f3a', '10.1016/j.autcon.2022.104256', 'Links physical building geometry with real-time energy consumption data for city-scale planning.', 'Conceptual gap in how "urban resilience" or "energy efficiency" is measured through a limited choice', 'Assumptions about the completeness of data layers; difficulty in validating if the chosen layers tru');
INSERT INTO FUSION_METHOD (m_name, m_key, m_doi, m_desc, u1, u3) VALUES ('Graph Convolutional Network (GCN) Fusion', 'e1f2a3b4-c5d6-4e7f-2a8b-9c0d1e2f3a4b', '10.1016/j.trc.2021.103234', 'Fuses network-based traffic flow with point-based weather and taxi demand data.', 'Assumes that "city hotspots" and their movements are the only necessary factors for an accurate mode', 'Prediction error increases for larger population sizes due to complex interactions; requires aggress');

-- Table: DATA
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.inffus.2023.102140', 'Comparative Benchmark Suite (Liar, ISOT, GM, COVID)', 'https://github.com/FFarhangian/Fake-news-detection-Comparative-Study', '7b8c9d0e-1f2a-4b3c-5d6e-7f8a9b0c1d2e', 'Multi-source aggregation including PolitiFact API,', 'Data represents a "closed-world" assumption; results may vary in "open');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.inffus.2023.102084', 'MS-COCO & Flickr30K Benchmark Suite', 'https://cocodataset.org/', 'a2b3c4d5-e6f7-4b8c-9d0e-1f2a3b4c5d6e', 'Crowdsourced annotations of images from Flickr (Fl', 'The datasets contain inherent selection bias as they rely on human des');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.inffus.2023.102076', 'IoMT Physiological Signal Simulation', 'N/A (Simulated)', 'e1f2a3b4-c5d6-4e7f-8g9h-0i1j2k3l4m5n', 'Simulated data collection representing wearable se', 'Simulated data may not fully capture the extreme "noisy" variability o');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.ipm.2023.103538', 'CMU-MOSI & CMU-MOSEI', 'https://github.com/A2ZAD/CMU-MultimodalSDK', 'b1e2a3f4-c5d6-4e7b-8a9c-0d1e2f3a4b5c', 'YouTube opinion videos manually transcribed and an', 'The data suffers from a "positivity bias" common in social media revie');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.autcon.2023.105156', 'FP-TXT (Enriched Floor Plan Dataset)', 'https://zenodo.org/record/7921780', 'c3d4e5f6-a7b8-4c9d-1e2f-3a4b5c6d7e8f', 'Synthetic generation using a custom pipeline + man', 'The dataset may have a "digital bias" because synthetic data often lac');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.2196/21926', 'Empatica E4 & IMU ADL Dataset', 'https://mhealth.jmir.org/2021/1/e21926/', '9f2a4c8b-d0e1-4f2a-9b3c-4d5e6f7a8b9c', 'Deep Learning–Based Multimodal Data Fusion', 'The paper specifically highlights issues like packet loss, battery dep');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1093/toxsci/kfaa187', 'KCC / ToxCast', 'https://academic.oup.com/toxsci/article/180/1/38/6066197', '2b3c4d5e-6f7a-8b9c-d0e1-f2a3b4c5d6e7', 'Key Characteristics of Carcinogens (KCC) approach', 'This paper relies on the Hidden Layer Representation. Errors here (U2)');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1109/ACCESS.2021.3090436', 'IR & Visible Dataset', 'https://ieeexplore.ieee.org/document/9459693', 'd4e5f6a7-b8c9-d0e1-f2a3-b4c5d6e7f8a9', 'LatLRR nested with RGIF', 'The paper addresses measurement-related limitations by isolating and r');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.3390/en14020468', 'NDBC / NCEP-NCAR', 'https://www.mdpi.com/1996-1073/14/2/468', 'e1f2a3b4-c5d6-4e7b-8a9c-0d1e2f3a4b5c', 'SC/ML Dataset Tool', 'The integration process must account for significant discrepancies in');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.neunet.2020.10.003', 'Unconstrained Video', 'https://www.sciencedirect.com/science/article/abs/pii/S0893608020303580?via%3Dihub', 'f7a8b9c0-d1e2-4f3a-b4c5-d6e7f8a9b0c1', 'Deep Multi-Modal Attention Network', 'Effective data analysis must account for sensor errors and resolution');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.bspc.2021.103140', 'One-to-Many  Dataset', NULL, 'ceb0cf47-88a5-433f-8641-a5e6461fbb47', 'Variable Focus Capture', 'Pixel misalignment.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.bspc.2021.103140', 'Image Target Area', NULL, '25e1bc16-75a9-4d56-ac62-f92ebd71dd57', 'Automated Segmentation', 'Inaccurate boundary detection.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.bspc.2021.103140', 'Image Background Area', NULL, '25e1bc16-75a9-4d56-ac62-f92ebd71dd57', 'Automated Segmentation', 'Noise artifacts within background pixels.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.3390/rs13204021', 'HRRP Data', NULL, '9cf9a596-8435-407d-b7ee-c7155a3b466e', 'High-resolution Radar', 'Signal noise and phase jitter.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.3390/rs13204021', 'SAR Images', NULL, '47dde933-2ff6-4fd8-a892-8a43837ab29f', 'Synthetic Aperture Radar', 'Speckle noise and occlusion.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.3390/rs13204021', 'MSTAR Dataset', 'https://www.sdms.afrl.af.mil/index.php?collection=mstar', '768d5187-a3b9-4f6e-bbef-176d7b5a809f', 'Airborne Radar', 'Limited target orientation variety.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.3390/rs13204021', 'Civilian Vehicle Dataset', NULL, '768d5187-a3b9-4f6e-bbef-176d7b5a809f', 'Controlled Imaging', 'Environment specific bias.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1007/s12161-021-02113-1', 'Mean Spectral Data', NULL, '60aa9e1e-e2c5-41ca-9009-927b88851550', 'Spectra Averaging ROI', 'ROI selection error.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1007/s12161-021-02113-1', 'Textural Information Data', NULL, '60aa9e1e-e2c5-41ca-9009-927b88851550', 'Gabor filter and GLCM', 'Heuristic texture parameter noise.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1007/s12161-021-02113-1', 'Pork Hyperspectral Images', NULL, '9ec75af9-6de4-40ad-9dbe-74fe3667daee', 'HSI Camera', 'Illumination non-uniformity.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.eswa.2021.115879', 'COVID19 PRIMO Dataset', NULL, 'd2cac3dd-bce2-4520-8f46-efb676f87b3d', 'Social Media Scraping', 'Social media ''fake news'' and noise.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.eswa.2021.115879', 'Scattered Social Media News', NULL, '20f39de3-4872-4e03-b9b4-f97a19c23919', 'Web Crawling', 'Informal language and sarcasm.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.eswa.2021.115879', 'Historical Market Data', NULL, 'de416191-de3c-475c-bf59-1ec0f1df90b7', 'Exchange Feeds', 'Reporting lags and corrections.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.displa.2021.102082', 'RGB Images (Indoor)', NULL, '18a95e8c-cb06-488c-95f7-e696b94c8f42', 'RGB Camera', 'Lighting and shadow noise.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.displa.2021.102082', 'Depth Maps (Indoor)', NULL, '18a95e8c-cb06-488c-95f7-e696b94c8f42', 'Kinect/Depth Sensors', 'Missing depth values on reflective surfaces.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.displa.2021.102082', 'NYUDv2 Dataset', 'https://cs.nyu.edu/~silberman/datasets/nyu_depth_v2.html', '18a95e8c-cb06-488c-95f7-e696b94c8f42', 'Kinect', 'Sensor noise at object boundaries.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.displa.2021.102082', 'SUN-RGBD Dataset', 'https://rgbd.cs.princeton.edu/', '18a95e8c-cb06-488c-95f7-e696b94c8f42', 'Multiple Depth Sensors', 'Inconsistency between different sensor types.');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1093/btab664', 'iHMP Diabetes', 'ihmpdcc.org', '7b741838-131c-43d6-ad92-1740b2d23513', 'Clinical longitudinal sampling', 'Missing data points due to irregular sampling intervals and high biolo');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.cct.2021', 'Steps for Change', NULL, 'd6f33158-aad8-47c5-acf3-91b88a471cbc', 'Accelerometry & Citizen Science App', 'Sensor malfunction, battery failure, and non-compliance in citizen sci');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1109/MAES.2021', 'Global Maritime Data', 'marinetraffic.com', 'ff66f67b-b064-4487-af2b-dba2b59f5a1c', 'RF Transponders & Remote Sensing', 'AIS signal shadowing, spoofing, and low temporal resolution of satelli');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1128/mSphere.21', 'PlasmoMitoCarta', 'plasmodb.org', 'dbe5b773-44ab-4ae6-8a0c-db27737bb4c9', 'Mass Spec & Bioinformatics', 'Resolution limits of mass spectrometry and experimental noise in prote');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.inffus.21', 'SAR Ship Imagery', 'copernicus.eu', '4fec9859-c698-467f-be6d-d8acb43681d5', 'Space (Sentinel-1) & Airborne SAR', 'Speckle noise, target scintillation, and resolution trade-offs between');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.envsoft.22', 'Urban Air Quality', 'aqicn.org', '8ad1cee9-9f92-4420-ad48-5fe321a98e40', 'IoT Sensor Networks', 'Calibration drift in low-cost sensors and spatial gaps between fixed m');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.isprsjprs.21', 'Urban Land Use', 'earthexplorer.usgs.gov', '43ee7847-8943-49dd-b516-5b5e4dd4ec98', 'Cloud cover interference in optical bands and geom', NULL);
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.cageo.21', 'Social Media Floods', 'twitter.com/dev', '0b5de03e-376e-45b5-a592-bfba2dbeb7e9', 'API Web Scraping', 'Geocoding inaccuracies, spam bots, and uneven user distribution during');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.autcon.22', 'Building IoT Energy', NULL, '1bc4891e-1c9e-4cdf-9f82-81e3a30e4f75', 'BIM models & Smart Meters', 'Connectivity latency in smart meters and outdated geometry/metadata in');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES ('10.1016/j.trc.2021', 'Multi-modal Traffic', 'tianchi.aliyun.com', 'aa3f077c-b7b5-47f8-872f-8abb9ba26f41', 'Loop Detectors & GPS Tracking', 'Missing GPS trajectories, sensor outages, and artifacts from aggressiv');
INSERT INTO DATA (d_doi, d_name, d_url, method_key, collection_method, u2) VALUES (NULL, NULL, NULL, NULL, NULL, NULL);

-- Table: DOI_AUTHOR
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102140', 'Faramarz Farhangian');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102140', 'Rafael M.O. Cruz');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102140', 'George D.C. Cavalcanti');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102084', 'Shichen Huang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102084', 'Weina Fu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102084', 'Zhaoyue Zhang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102084', 'Shuai Liu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102076', 'Mian Ahmad Jan');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102076', 'Wenjing Zhang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102076', 'Fazlullah Khan');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102076', 'Sohail Abbas');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2023.102076', 'Rahim Khand');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Qiang Lu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Xia Sun');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Zhize Zhang Gao');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Yunfei Long');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Jun Feng');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.ipm.2023.103538', 'Hao Zhang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.autcon.2023.105156', 'Phillip Schönfelder');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.autcon.2023.105156', 'Fynn Stebel');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.autcon.2023.105156', 'Nikos Andreou');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.autcon.2023.105156', 'Markus König');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.2196/21926', 'Nooshir Bahador');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.2196/21926', 'Denzil Ferreira');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.2196/21926', 'Satu Tamminen');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.2196/21926', 'Jukka Kortelainen');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/toxsci/kfaa187', 'Grace A. Chappell');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/toxsci/kfaa187', 'Daniele S. Wikoff');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/toxsci/kfaa187', 'Chad M. Thompson');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/ACCESS.2021.3090436', 'Ce Gao');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/ACCESS.2021.3090436', 'Congcong Song');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/ACCESS.2021.3090436', 'Yanchao Zhang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/ACCESS.2021.3090436', 'Donghao Qi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/ACCESS.2021.3090436', 'Yi Yu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/en14020468', 'Antonio Manuel Gomez-Orellana');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/en14020468', 'Juan Carlos Fernandez');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/en14020468', 'Manuel Dorado-Moreno');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/en14020468', 'Pedro Antonio Gutierrez');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/en14020468', 'Cesar Hervas-Martinez');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Ruihan Hu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Songbing Zhou');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Zhi Ri Tang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Sheng Chang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Qijun Huang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Yisen Liu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Wei Han');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.neunet.2020.10.003', 'Edmond Q. Wu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.bspc.2021.103140', 'Feng-Ping An');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.bspc.2021.103140', 'Xing-min Ma');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.bspc.2021.103140', 'Lei Bai');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Lan Du');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Lu Li');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Yuchen Guo');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Yan Wang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Ke Ren');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.3390/rs13204021', 'Jian Chen');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1007/s12161-021-02113-1', 'Christopher T. Kucha');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1007/s12161-021-02113-1', 'Li Liu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1007/s12161-021-02113-1', 'Michael Ngadi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1007/s12161-021-02113-1', 'Claude Gariepy');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.eswa.2021.115879', 'Farnoush Ronaghi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.eswa.2021.115879', 'Mohammad Salimibeni');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.eswa.2021.115879', 'Farnoosh Naderkhani');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.eswa.2021.115879', 'Arash Mohammadi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.displa.2021.102082', 'Xingchao Yan');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.displa.2021.102082', 'Sujuan Hou');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.displa.2021.102082', 'Awudu Karim');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.displa.2021.102082', 'Weikuan Jia');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/bioinformatics/btab664', 'Antoine Bodein');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/bioinformatics/btab664', 'Marie-Pier Scott-Boyer');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/bioinformatics/btab664', 'Olivier Perin');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/bioinformatics/btab664', 'Kim-Anh Lê Cao');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1093/bioinformatics/btab664', 'Arnaud Droit');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Abby C. King');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Maria I. Campero');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Dulce Garcia');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Isela Blanco-Velazquez');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Ann Banchoff');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Fernando Fierros');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Michele Escobar');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Ana L. Cortes');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Jylana L. Sheats');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Jenna Hua');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Aldo Chazaro');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Monica Done');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Patricia Rodriguez Espinosa');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'Daniel Vuong');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.cct.2021.106526', 'David K. Ahn');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Giovanni Soldi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Domenico Gaglione');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Nicola Forti');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Alessio Di Simone');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Filippo Cristian Daffina');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Gianfausto Bottini');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Dino Quattrociocchi');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Leonardo M. Millefiori');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Paolo Braca');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Sandro Carniel');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Peter Willett');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Antonio Iodice');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Daniele Riccio');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1109/MAES.2021.3070884', 'Alfonso Farina');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Selma L. van Esveld');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Lisette Meerstein-Kessel');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Cas Boshoven');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Jochem F. Baaij');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Konstantin Barylyuk');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Jordy P. M. Coolen');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Joeri van Strien');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Ronald A. J. Duim');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Bas E. Dutilh');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Daniel R. Garza');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Marijn Letterie');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Nicholas I. Proellochs');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Michelle N. de Ridder');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Prashanna Balaji Venkatasubramanian');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Laura E. de Vries');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Ross F. Waller');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Taco W. A. Kooij');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1128/mSphere.00614-21', 'Martijn A. Huynen');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2021.07.019', 'Xueqian Wang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2021.07.019', 'Dong Zhu');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2021.07.019', 'Gang Li');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2021.07.019', 'Xiao-Ping Zhang');
INSERT INTO DOI_AUTHOR (a_doi, author) VALUES ('10.1016/j.inffus.2021.07.019', 'You He');