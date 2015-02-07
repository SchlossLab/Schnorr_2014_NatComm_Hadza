################################################################################
#
#	Part 1: Get the reference files
#
#	Here we give instructions on how to get the necessary reference files that
#	are used throughout the rest of the analysis. These are used to calculate
#	error rates, generate alignments, and classify sequences. We will pull down
#	the mock community reference (HMP_MOCK.fasta), the silva reference alignment
#	(silva.bacteria.align), and the RDP training set data (both trainset9_032012
#	and trainset10_082014).
#
#	The targets in this part are all used as dependencies in other rules
#
################################################################################

#Location of reference files
REFS = data/references/

#get the silva reference alignment
$(REFS)silva.bacteria.align :
	wget -N -P $(REFS) http://www.mothur.org/w/images/2/27/Silva.nr_v119.tgz; \
	tar xvzf $(REFS)Silva.nr_v119.tgz -C $(REFS);
	mothur "#get.lineage(fasta=$(REFS)silva.nr_v119.align, taxonomy=$(REFS)silva.nr_v119.tax, taxon=Bacteria)";
	mv $(REFS)silva.nr_v119.pick.align $(REFS)silva.bacteria.align; \
	rm $(REFS)README.html; \
	rm $(REFS)README.Rmd; \
	rm $(REFS)silva.nr_v119.*

#get the v4 region of the alignment
$(REFS)silva.v4.align : $(REFS)silva.bacteria.align
	mothur "#pcr.seqs(fasta=$(REFS)silva.bacteria.align, start=11894, end=25319, keepdots=F, processors=8);\
			unique.seqs(fasta=current);"; \
	mv $(REFS)silva.bacteria.pcr.unique.align $(REFS)silva.v4.align; \
	rm $(REFS)silva.bacteria.pcr.*

#get the rdp training set data (v9)
$(REFS)trainset9_032012.pds.tax $(REFS)trainset9_032012.pds.fasta :
	wget -N -P $(REFS) http://www.mothur.org/w/images/5/59/Trainset9_032012.pds.zip;\
	unzip -o $(REFS)Trainset9_032012.pds.zip -d $(REFS);

#get the V4 region of the RDP training set (v9)
$(REFS)trainset9_032012.v4.tax $(REFS)trainset9_032012.v4.fasta : \
                                                $(REFS)trainset9_032012.pds.tax \
                                                $(REFS)trainset9_032012.pds.fasta \
                                                $(REFS)silva.v4.align
	mothur "#align.seqs(fasta=$(REFS)trainset9_032012.pds.fasta, reference=$(REFS)silva.v4.align, processors=8);\
		screen.seqs(fasta=current, taxonomy=$(REFS)trainset9_032012.pds.tax, start=1968, end=11550);\
		degap.seqs(fasta=current)";\
	mv $(REFS)trainset9_032012.pds.good.ng.fasta $(REFS)trainset9_032012.v4.fasta;\
	mv $(REFS)trainset9_032012.pds.good.tax $(REFS)trainset9_032012.v4.tax;\
	rm data/references/trainset9_032012.pds.align*;\
	rm data/references/trainset9_032012.pds.bad.accnos;\
	rm data/references/trainset9_032012.pds.flip.accnos;


#get the rdp training set data (v10)
$(REFS)trainset10_082014.pds.tax $(REFS)trainset10_082014.pds.fasta :
        wget -N -P $(REFS) http://www.mothur.org/w/images/2/24/Trainset10_082014.pds.tgz; \
        tar xvzf $(REFS)Trainset10_082014.pds.tgz -C $(REFS);\
        mv $(REFS)trainset10_082014.pds/trainset10_082014.* $(REFS);\
        rm -rf $(REFS)trainset10_082014.pds


#get the V4 region of the RDP training set (v10)
$(REFS)trainset10_082014.v4.tax $(REFS)trainset10_082014.v4.fasta : \
						$(REFS)trainset10_082014.pds.tax \
						$(REFS)trainset10_082014.pds.fasta \
						$(REFS)silva.v4.align
	mothur "#align.seqs(fasta=$(REFS)trainset10_082014.pds.fasta, reference=$(REFS)silva.v4.align, processors=8);\
		screen.seqs(fasta=current, taxonomy=$(REFS)trainset10_082014.pds.tax, start=1968, end=11550);\
		degap.seqs(fasta=current)"; \
	mv $(REFS)trainset10_082014.pds.good.ng.fasta $(REFS)trainset10_082014.v4.fasta; \
	mv $(REFS)trainset10_082014.pds.good.tax $(REFS)trainset10_082014.v4.tax;\
	rm data/references/trainset10_082014.pds.align*;\
	rm data/references/trainset10_082014.pds.bad.accnos;\
	rm data/references/trainset10_082014.pds.flip.accnos;


################################################################################
#
#	Part 2: Run data through mothur
#
#
################################################################################





################################################################################
#
#	Part 3: Blog entries
#
################################################################################




################################################################################
#
#	Part 5: Everything
#
#
################################################################################

