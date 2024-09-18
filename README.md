# LockedIn (aka Study-Space)

LockedIn is a VisionOS app for the Apple Vision Pro, built at Hack The North 2024.

# Preview

<table>
  <tr>
    <td><img width="720" alt="Screenshot_2024-09-15_at_4 06 43_AM" src="https://github.com/user-attachments/assets/7a5df4d8-eb7f-459e-b48e-42e070215c64"></td>
    <td><img width="720" alt="Screenshot_2024-09-15_at_4 07 10_AM" src="https://github.com/user-attachments/assets/d19d96d4-88ae-46a7-9be4-559df4c5d0ab"></td>
  </tr>
  <tr>
    <td><img width="720" alt="Screenshot_2024-09-15_at_4 07 57_AM" src="https://github.com/user-attachments/assets/5f3a6eb7-95f6-4d29-9a7e-bfd8e1e84a30"></td>
    <td><img width="720" alt="Screenshot_2024-09-15_at_4 08 44_AM" src="https://github.com/user-attachments/assets/1b83e5cc-d5c1-4785-83ae-6c6ad397492a"></td>
  </tr>
  <tr>
    <td><img width="720" alt="Screenshot_2024-09-15_at_4 09 28_AM" src="https://github.com/user-attachments/assets/fbbf869d-79e1-4e94-8373-e8f0ad577efd"></td>
  </tr>
</table>

# Demo

**To see it in action**, check this video out: https://www.youtube.com/watch?v=gdu7u9qX8E0

# Description

Ever found yourself tasked with reading a dense research paper, a data structures and algorithms textbook, or even *The Very Hungry Caterpillar*? Sometimes you're "in the zone," but other times, concentration feels impossible—whether due to distractions, lack of coffee, or looming deadlines. That's why we built this app: to help you get "Locked In" and truly understand the material!

### How It Works

It’s simple:
- Upload a PDF, or purchase it from our embedded Shopify store.
- Once uploaded, click on the file to start reading. The document is stored on AWS S3, with metadata.
- Need to focus? Switch to "Locked In" mode! 
  - This mode features ambient music to reduce background noise and a themed background related to the subject you're studying. For example, if you're reading a Chemistry book, the background may resemble a lab setting.

### Features

We didn’t stop at basic functionality—here’s what sets the app apart:
- **AI-Powered Tools:** We’ve integrated two AI features built with Cohere:
  1. **Summarizer:** This tool simplifies the page you're reading by summarizing it in plain English, making it accessible even at a Grade 7 level. Anyone can grasp the key points!
  2. **Interactive Chatbot:** Ask it questions via your microphone, and it will respond based on the context of the reading. For example, if you're reading about gravity, it will answer questions about Isaac Newton—but won't tell you how to cook spaghetti (you should know that anyway!).
  
- **3D Object Visualization:** Want to interact with the objects you're reading about? Simply look at the object, pinch your fingers, and you'll see a 3D model of it. Our current implementation supports chemical molecules, and with enough interest, we could expand this feature with a library of interactive objects that map to keywords in the text.

- **Math Visualization:** If your textbook contains math equations, just look at the equation and pinch your fingers—BOOM! An interactive graph of the equation appears, allowing you to explore it further.

- **Math Solver:** We aim to build a Photomath-like algorithm that identifies math problems on the page and solves them. It converts the PDF text into LaTeX and solves it using a math model. Due to time and resource constraints, we opted for a basic Cohere chatbot to handle math problems for now (we had hoped to implement a more robust solver).

And that’s about it! Thank you for reading! 


# Links

Demo [video](https://www.youtube.com/watch?v=gdu7u9qX8E0)

Our backend [repo](https://github.com/mingchungx/Study-Space-backend)

Devpost [project](https://devpost.com/software/lockedin-4rvey8)


# Authors

Thomas Semczyszyn (University of Toronto)

Nick Pestov (University of Toronto)

Jared Drueco (University of Alberta)

Mingchung Xia (University of Waterloo)

