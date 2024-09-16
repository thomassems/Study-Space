# LockedIn (aka Study-Space)

LockedIn is a visionOS app for the Apple Vision Pro, built at Hack The North 2024.


**To see it in action**, check this video out: https://www.youtube.com/watch?v=gdu7u9qX8E0


Ever tasked with reading a research paper, a data structures and algorithms textbook, or The Very Hungry Caterpillar? 

Sometimes, we're "in the zone", and sometimes, we simply cannot concentrate, whether it be due to surroundings, lack of coffee, or tight deadlines, we made this app to help get you "Locked In" and thoroughly understand the material! 

How it works is very simple: 
- Upload a pdf, or purchase it from our store (it's not a real store, if actually deployed, we'd try to make it free)
- Once it's uploaded, simply click on the reading you uploaded, and start reading. The file itself gets stored on AWS S3 and the metadata (we didn't fully implement it) in Convex.
- If you need to get into the zone, go into "Locked In" Mode! 
  - Here, ambient music starts to play to reduce background noise, and the background changes to be related to the subject at hand, for example a lab, if you are reading a Chemistry book

Now that's cool, but how did we make it cooler?
- Firstly, we have 2 AI tools at your disposal, both built from Cohere:
  - We have a summarizer, which simply takes the page at hand, and summarizes is it in lower level English (like grade 7 level for example), so anyone can understand the main details!
  - Second tool is an interactive Chatbot. You simply ask it questions via the microphone, and it responds to your questions. We programmed it, so that it takes the context of the reading, and only allows input to related   questions. For example, a reading on gravity and motion, would answer questions related to Isaac Newton's contributions, but would not respond to, "How do I cook Spaghetti" (you should know this anyways!).
- We visualized math equations! If a math textbook has an equation on the page, simply look at it and pinch your fingers, and BOOM, you got yourself an interactive graph that you can play around with of the equation at hand!
- Want to see the physical objects in the reading? Easy, same thing, look at the object, pinch your fingers, and you get a 3D model of the object to interact with. Unfortunately, we did not have a large enough library of these objects and time to implement more, so we only made it so that it can show chemical molecules. If there's interest, we'd revisit this, likely implementing some sort of library with these objects that would get mapped to keywords within the text.
  - Math solver. Although not in the actual project itself, we did create an algorithm like Photomath, that identifies a math problem on the page, and solves it. It converts the pdf text to Latex, where it is then solved using a Math Model (unfortunately the ones we could use quickly were all not free, so we opted for a basic Cohere chatbot to solve these (Yes, not ideal, we wanted a concrete solver too))

Yeah, and that's about it, thank you for reading!


Our backend repo is [here](https://github.com/mingchungx/Study-Space-backend).

Devpost project: https://devpost.com/software/lockedin-4rvey8?ref_content=user-portfolio&ref_feature=in_progress

<img width="1440" alt="Screenshot_2024-09-15_at_4 06 43_AM" src="https://github.com/user-attachments/assets/7a5df4d8-eb7f-459e-b48e-42e070215c64">
<img width="1440" alt="Screenshot_2024-09-15_at_4 07 10_AM" src="https://github.com/user-attachments/assets/d19d96d4-88ae-46a7-9be4-559df4c5d0ab">
<img width="1440" alt="Screenshot_2024-09-15_at_4 07 57_AM" src="https://github.com/user-attachments/assets/5f3a6eb7-95f6-4d29-9a7e-bfd8e1e84a30">
<img width="1440" alt="Screenshot_2024-09-15_at_4 08 44_AM" src="https://github.com/user-attachments/assets/1b83e5cc-d5c1-4785-83ae-6c6ad397492a">
<img width="1440" alt="Screenshot_2024-09-15_at_4 09 28_AM" src="https://github.com/user-attachments/assets/fbbf869d-79e1-4e94-8373-e8f0ad577efd">
<img width="1440" alt="Screenshot_2024-09-15_at_4 09 35_AM" src="https://github.com/user-attachments/assets/240c1b47-43e6-4457-b8db-c5d56cf86943">

# Authors

Thomas Semczyszyn (University of Toronto)

Nick Pestov (University of Toronto)

Jared Drueco (University of Alberta)

Mingchung Xia (University of Waterloo)

